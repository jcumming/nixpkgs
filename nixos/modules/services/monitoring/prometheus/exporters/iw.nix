{ config, pkgs, lib, ... }:

with lib;

let 
  cfg = config.services.prometheus.exporters.iw;
in 

assert config.services.hostapd.enabled # otherwise don't bother
{
  port = 6798;

  serviceOpts = {
    after = [ "hostapd-wlp4s0.service" "hostapd-wlp8s0.service" ]; # XXX: need to pull these from config.hostapd
      mapAttrsToList
        (ifName: ifCfg: nameValuePair "hostapd-${ifName}" (hostapdService ifName ifCfg))
        cfg.interfaces
    
    path = [ pkgs.iw ];

    serviceConfig = {
      RestrictAddressFamilies = [
        "AF_UNIX" # Need AF_UNIX to collect data
      ];

      ExecStart = ''
        ${pkgs.prometheus-iw-exporter}/bin/iw_exporter -http ${cfg.listenAddress}:${toString cfg.port}
      '';
    };
  };
}
