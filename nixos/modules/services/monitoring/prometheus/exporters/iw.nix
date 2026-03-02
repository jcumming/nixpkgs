{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.iw;
  inherit (lib) concatStringsSep;
in
{
  port = 6798;
  serviceOpts = {
    path = [ pkgs.iw ];
    serviceConfig = {
      RestrictAddressFamilies = [ "AF_UNIX" "AF_NETLINK" ];

      ExecStart = ''
        ${pkgs.prometheus-iw-exporter}/bin/iw_exporter \
          -http ${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
