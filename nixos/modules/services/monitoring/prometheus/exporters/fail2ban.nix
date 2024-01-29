{ config, pkgs, lib, ... }:

with lib;

let cfg = config.services.prometheus.exporters.fail2ban;

in {
  port = 6798;
  
  extraOpts = {
    socketPath = mkOption {
      type = types.path;            
      default = "/var/run/fail2ban/fail2ban.sock";
      example = "/var/lib/fail2ban/fail2ban.sock";
      description = lib.mdDoc ''
        Path under which the fail2ban socket is placed.
        The user/group under which the exporter runs,
        should be able to access the socket in order
        to scrape the metrics successfully.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      RestrictAddressFamilies = [ "AF_UNIX" "AF_NETLINK" ];

      ExecStart = ''
        ${pkgs.prometheus-fail2ban-exporter}/bin/fail2ban-prometheus-exporter \
          --web.listen-address=${cfg.listenAddress}:${toString cfg.port} \
          --collector.f2b.socket=${cfg.socketPath}
      '';
    };
  };
}
