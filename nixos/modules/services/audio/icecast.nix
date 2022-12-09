{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.icecast;
  configFile = pkgs.writeText "icecast.xml" (''
    <icecast>
      <hostname>${cfg.hostname}</hostname>

      <authentication>
        <admin-user>${cfg.admin.user}</admin-user>
        <admin-password>${cfg.admin.password}</admin-password>
      </authentication>

      <paths>
        <logdir>${cfg.logDir}</logdir>
        <adminroot>${pkgs.icecast}/share/icecast/admin</adminroot>
        <webroot>${pkgs.icecast}/share/icecast/web</webroot>
        <alias source="/" dest="/status.xsl"/>
      </paths>
    '' 
    + (concatMapStrings ( l: ''
        <listen-socket>
          <port>${toString l.port}</port>
          <bind-address>${l.ip}</bind-address>
        </listen-socket>   
      '' ) cfg.listen) 
    + ''
      <security>
        <chroot>0</chroot>
        <changeowner>
            <user>${cfg.user}</user>
            <group>${cfg.group}</group>
        </changeowner>
      </security>

      ${cfg.extraConf}
    </icecast>
  '');

in {

  ###### interface
  options = {

    services.icecast = {

      enable = mkEnableOption (lib.mdDoc "Icecast server");

      hostname = mkOption {
        type = types.nullOr types.str;
        description = lib.mdDoc "DNS name or IP address that will be used for the stream directory lookups or possibily the playlist generation if a Host header is not provided.";
        default = config.networking.domain;
        defaultText = literalExpression "config.networking.domain";
      };

      admin = {
        user = mkOption {
          type = types.str;
          description = lib.mdDoc "Username used for all administration functions.";
          default = "admin";
        };

        password = mkOption {
          type = types.str;
          description = lib.mdDoc "Password used for all administration functions.";
        };
      };

      logDir = mkOption {
        type = types.path;
        description = lib.mdDoc "Base directory used for logging.";
        default = "/var/log/icecast";
      };
      
     listen = mkOption {
         type = types.listOf (types.submodule (
              {
                options = {
                  port = mkOption {
                    type = types.port;
                    description = lib.mdDoc "TCP port that will be used to accept client connections.";
                  };
                  ip = mkOption {
                    type = types.str;
                    default = "*";
                    description = lib.mdDoc "IP address to listen on. 0.0.0.0 for ipv4 only, * for all.";
                  };
                };
              } ));
        description = lib.mdDoc ''
          List of ip/ports { ip = "127.0.0.1"; port = 8000;} to listen on
        '';

        default = [ { ip = "127.0.0.1"; port = 8000; } ];
      };

      user = mkOption {
        type = types.str;
        description = lib.mdDoc "User privileges for the server.";
        default = "nobody";
      };

      group = mkOption {
        type = types.str;
        description = lib.mdDoc "Group privileges for the server.";
        default = "nogroup";
      };

      extraConf = mkOption {
        type = types.lines;
        description = lib.mdDoc "icecast.xml content.";
        default = "";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.icecast = {
      after = [ "network.target" ];
      description = "Icecast Network Audio Streaming Server";
      wantedBy = [ "multi-user.target" ];

      preStart = "mkdir -p ${cfg.logDir} && chown ${cfg.user}:${cfg.group} ${cfg.logDir}";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.icecast}/bin/icecast -c ${configFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };

  };

}
