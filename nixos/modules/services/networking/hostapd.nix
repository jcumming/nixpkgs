{ config, lib, pkgs, utils, ... }:

# TODO:
#
# asserts
#   wpa_supplicant and hostapd on the same wireless interface doesn't make any sense
#
# support old format (if devices is not set)
#

with lib;

let

  cfg = config.services.hostapd;

  mkConfigFile = ifName: ifCfg: pkgs.writeText "hostapd.conf" ''
    # logging (debug level)
    logger_syslog=-1
    logger_syslog_level=${toString cfg.logLevel}
    logger_stdout=-1
    logger_stdout_level=${toString cfg.logLevel}

    ctrl_interface=/run/hostapd-${ifName}
    ctrl_interface_group=${cfg.group}

    interface=${ifName}

    ${optionalString (cfg.countryCode != null) ''country_code=${cfg.countryCode}''}
    ${optionalString (cfg.countryCode != null) ''ieee80211d=1''}

    ${optionalString ifCfg.noScan "noscan=1"}

    ${if ifCfg.bridge != "" then "bridge=${cfg.bridge}" else ""}

    driver=${ifCfg.driver}
    hw_mode=${ifCfg.hwMode}
    channel=${toString ifCfg.channel}

    ${ifCfg.extraConfig}
  '' ;

in

{
  ###### interface
 
  options = {

    services.hostapd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable putting a wireless interface into infrastructure mode,
          allowing other wireless devices to associate with the wireless
          interface and do wireless networking. A simple access point will
          {option}`enable hostapd.wpa`,
          {option}`hostapd.wpaPassphrase`, and
          {option}`hostapd.ssid`, as well as DHCP on the wireless
          interface to provide IP addresses to the associated stations, and
          NAT (from the wireless interface to an upstream interface).
        '';
      };

      group = mkOption {
        default = "wheel";
        example = "network";
        type = types.str;
        description = lib.mdDoc ''
          Members of this group can control {command}`hostapd`.
        '';
      };

      logLevel = mkOption {
        default = 2;
        type = types.int;
        description = lib.mdDoc ''
          Levels (minimum value for logged events):
          0 = verbose debugging
          1 = debugging
          2 = informational messages
          3 = notification
          4 = warning
        '';
      };

      countryCode = mkOption {
        default = null;
        example = "US";
        type = with types; nullOr str;
        description = lib.mdDoc ''
          Country code (ISO/IEC 3166-1). Used to set regulatory domain.
          Set as needed to indicate country in which device is operating.
          This can limit available channels and transmit power.
          These two octets are used as the first two octets of the Country String
          (dot11CountryString).
          If set this enables IEEE 802.11d. This advertises the countryCode and
          the set of allowed channels and transmit power levels based on the
          regulatory limits.
        '';
      };

      interfaces = mkOption {
        default = {};
        example = { 
          wlp2s0 = {
            hwMode="g";
            channel=1;
            extraConfig=''
              wmm_enabled=1
              ieee80211n=1
              ht_capab=[DSSS_CCK-40][LDPC][TX-STBC][RX-STBC1]
            '';
          };
        };
        description = lib.mdDoc ''
          Wireless interfaces hostapd will run in infrastructure mode. A dual
          band Access Point is 2 different interfaces running on different frequency
          bands (different hwMode). The hostapd shall be configured to bind to the same
          bridge interface. 
        '';
        type = types.attrsOf (types.submodule (
        {
          options = { 
            bridge = mkOption {
              default = "";
              example = "br0";
              type = types.str;
              description = lib.mdDoc ''
                More complex AP setups may wish have hostapd add the wireless interfaces to a bridge
              '';
            };

            channel = mkOption {
              default = 7;
              example = 11;
              type = types.int;
              description = lib.mdDoc ''
                Channel number (IEEE 802.11)
                Please note that some drivers do not use this value from
                <command>hostapd</command> and the channel will need to be configured
                separately with <command>iwconfig</command>.
              '';
            };

            driver = mkOption {
              default = "nl80211";
              example = "hostapd";
              type = types.str;
              description = lib.mdDoc ''
                Which driver <command>hostapd</command> will use.
                Most applications will probably use the default.
              '';
            };

            hwMode = mkOption {
              default = "g";
              type = types.enum [ "a" "b" "g" ];
              description = lib.mdDoc ''
                Operation mode.
                (a = IEEE 802.11a/ac, b = IEEE 802.11b, g = IEEE 802.11g).
              '';
            };

            noScan = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                Do not scan for overlapping BSSs in HT40+/- mode.
                Caution: turning this on will violate regulatory requirements!
              '';
            };

            ssid = mkOption {
              default = "nixos";
              example = "mySpecialSSID";
              type = types.str;
              description = lib.mdDoc "SSID to be used in IEEE 802.11 management frames.";
            };

            wpa = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc ''
                Enable WPA2 (IEEE 802.11i/RSN) to authenticate with the access point.
              '';
            };

            wpaPassphrase = mkOption {
              default = "my_sekret";
              example = "any_64_char_string";
              type = types.str;
              description = lib.mdDoc ''
                WPA-PSK (pre-shared-key) passphrase. Clients will need this
                passphrase to associate with this access point.
                Warning: This passphrase will get put into a world-readable file in
                the Nix store!
              '';
            };

            extraConfig = mkOption {
              default = "";
              example = ''
                auth_algo=1
                ieee80211n=1
                ht_capab=[HT41-][SHORT-GI-40][DSSS_CCK-40]
                '';
              type = types.lines;
              description = lib.mdDoc "Extra configuration options to put in hostapd.conf.";
            };
          };
        }));
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages =  [ pkgs.hostapd ];

    services.udev.packages = optionals (cfg.countryCode != null) [ pkgs.crda ];

    systemd.services = 
    let 
      hostapdService = ifName: ifCfg: {
        description = "hostapd wireless AP - ${ifName}";

        path = [ pkgs.hostapd ];

        after = [ "nat.service" "bind.service" "dhcpd.service" "sys-subsystem-net-devices-${ifName}.device" ];
        bindsTo = [ "sys-subsystem-net-devices-${ifName}.device" ];
        requiredBy = [ "network-link-${ifName}.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = { 
          ExecStart = "${pkgs.hostapd}/bin/hostapd ${mkConfigFile ifName ifCfg }";
          Restart = "always";
        };
      };
    in
    listToAttrs (
      mapAttrsToList
        (ifName: ifCfg: nameValuePair "hostapd-${ifName}" (hostapdService ifName ifCfg))
        cfg.interfaces
    );
  };
}
