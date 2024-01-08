{ config, pkgs, lib, ... }:

with lib;

let cfg = config.services.prometheus.exporters.iw;

in {
  port = 6798;

  serviceOpts = {
    path = [ pkgs.iw ];

    serviceConfig = {
      RestrictAddressFamilies = [ "AF_UNIX" "AF_NETLINK" ];

      ExecStart = ''
        ${pkgs.prometheus-iw-exporter}/bin/iw_exporter -http ${cfg.listenAddress}:${toString cfg.port}
      '';
    };
  };
}
