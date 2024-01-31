{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.nut;
in
{
  port = 9199;
  extraOpts = {
    nutServer = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        Hostname or address of the NUT server
      '';
    };
    nutUser = mkOption {
      type = types.str;
      default = "";
      example = "nut";
      description = lib.mdDoc ''
        The user to log in into NUT server. If set, passwordPath should
        also be set.

        Default NUT configs usually permit reading variables without
        authentication.
      '';
    };
    exporterMetricsPath = mkOption {
      type = types.str;
      default = "/exporter_metrics";
      example = "/expoter";
      description = lib.mdDoc ''
        Path under which to expose process metrics about this exporter.

        The default is different than the exporter default; users are more
        likely interested in UPS stats than stats about the nut exporter.
      '';
    };
    metricsPath = mkOption {
      type = types.str;
      default = "/metrics";
      example = "/ups_metrics";
      description = lib.mdDoc ''
        Path under which to expose the UPS Prometheus metrics.

        The default is different than the exporter default; users are more
        likely interested in UPS stats than stats about the nut exporter.
      '';
    };
    passwordPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      apply = final: if final == null then null else toString final;
      description = lib.mdDoc ''
        A run-time path to the nutUser password file, which should be
        provisioned outside of Nix store.
      '';
    };
  };
  serviceOpts = {
    script = ''
      ${optionalString (cfg.passwordPath != null)
      "export NUT_EXPORTER_PASSWORD=$(cat ${toString cfg.passwordPath})"}
      ${pkgs.prometheus-nut-exporter}/bin/nut_exporter \
        --nut.server=${cfg.nutServer} \
        --web.listen-address="${cfg.listenAddress}:${toString cfg.port}" \
        --web.telemetry-path="${cfg.metricsPath}" \
        --web.exporter-telemetry-path="${cfg.exporterMetricsPath}" \
        ${optionalString (cfg.nutUser != "") "--nut.username=${cfg.nutUser}"}
    '';
  };
}
