let
  defaultSettings = {
    DARKTABLE_PRESETS = "false";
    DEBUG = "true";
    DETECT_NSFW = "true";
    EXPERIMENTAL = "true";
    HTTP_MODE = "release";
    JPEG_QUALITY = 92;
    JPEG_SIZE = 7680;
    ORIGINALS_LIMIT = 1000000;
    PUBLIC = "false";
    READONLY = "false";
    SETTINGS_HIDDEN = "false";
    SIDECAR_JSON = "true";
    SIDECAR_YAML = "true";
    SITE_CAPTION = "Browse Your Life";
    SITE_TITLE = "PhotoPrism";
    THUMB_FILTER = "linear";
    THUMB_SIZE = 2048;
    THUMB_SIZE_UNCACHED = 7680;
    THUMB_UNCACHED = "true";
    UPLOAD_NSFW = "true";
    WORKERS = 16;
  };
in
  {
    lib,
    pkgs,
    config,
    ...
  }: let
    cfg = config.services.photoprism;
  in {
    options = with lib; {
      services.photoprism = {
        enable = mkEnableOption "photoprism";

        settings = mkOption {
          type = types.attrs;
          description = ''
            [Environment variable](https://docs.photoprism.app/getting-started/config-options/) set before executing photoprism.
            The resultant environment variable will have `PHOTOPRISM_` prepended. (i.e. WORKERS = 8 sets PHOTOPRISM_WORKERS = 8).
          '';
          default = defaultSettings;
        };

        keyFile = mkOption {
          type = types.bool;
          default = false;
          description = ''
            for sops path
             sops.secrets.photoprism-password = {
               owner = "photoprism";
               sopsFile = ../../secrets/secrets.yaml;
               path = "/var/lib/photoprism/keyFile";
             };
             #PHOTOPRISM_ADMIN_PASSWORD=<yourpassword>
          '';
        };

        dataDir = mkOption {
          type = types.path;
          default = "/var/lib/photoprism";
          description = ''
            Data directory for photoprism
          '';
        };

        originalsDir = mkOption {
          type = types.path;
          default = "/var/lib/photoprism";
          description = ''
            Original Media directory for photoprism
          '';
        };

<<<<<<< HEAD
        package = mkOption {
          type = types.package;
          default = pkgs.photoprism;
          defaultText = literalExpression "pkgs.photoprism";
          description = "The photoprism package.";
        };
=======
    address = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = ''
        Web interface address.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 2342;
      description = ''
        Web interface port.
      '';
    };

    originalsPath = lib.mkOption {
      type = lib.types.path;
      default = null;
      example = "/data/photos";
      description = ''
        Storage path of your original media files (photos and videos).
      '';
    };

    importPath = lib.mkOption {
      type = lib.types.str;
      default = "import";
      description = ''
        Relative or absolute to the `originalsPath` from where the files should be imported.
      '';
    };

    storagePath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/photoprism";
      description = ''
        Location for sidecar, cache, and database files.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "photoprism";
      description = "User under which photoprism runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "photoprism";
      description = "Group under which photoprism runs.";
    };

    package = lib.mkPackageOption pkgs "photoprism" { };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        See [the getting-started guide](https://docs.photoprism.app/getting-started/config-options/) for available options.
      '';
      example = {
        PHOTOPRISM_DEFAULT_LOCALE = "de";
        PHOTOPRISM_ADMIN_USER = "root";
>>>>>>> 2fa5eae119ef4411a784c3575eb709aaf9f78be8
      };
    };

    config = with lib;
      mkIf cfg.enable {
        users.users.photoprism = {
          isSystemUser = true;
          group = "photoprism";
        };

<<<<<<< HEAD
        users.groups.photoprism = {};
=======
      serviceConfig = {
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = true;
        StateDirectory = "photoprism";
        WorkingDirectory = cfg.storagePath;
        RuntimeDirectory = "photoprism";
        ReadWritePaths = [
          cfg.originalsPath
          cfg.importPath
          cfg.storagePath
        ];
>>>>>>> 2fa5eae119ef4411a784c3575eb709aaf9f78be8

        systemd.services.photoprism = {
          enable = true;
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = ["multi-user.target"];

          confinement = {
            enable = true;
            binSh = null;
            packages = [
              pkgs.darktable
              pkgs.ffmpeg
              pkgs.exiftool
              cfg.package
              pkgs.cacert
            ];
          };

          path = [
            pkgs.darktable
            pkgs.ffmpeg
            pkgs.exiftool
          ];

          script = ''
            exec ${cfg.package}/bin/photoprism start
          '';

          serviceConfig = {
            User = "photoprism";
            RuntimeDirectory = "photoprism";
            CacheDirectory = "photoprism";
            StateDirectory = "photoprism";
            SyslogIdentifier = "photoprism";
            LockPersonality = true;
            MemoryDenyWriteExecute = false;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateTmp = true;
            PrivateUsers = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            RemoveIPC = true;
            RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallErrorNumber = "EPERM";
            SystemCallFilter = ["@system-service" "~@privileged" "~@resources"];
            UMask = "0066";
            EnvironmentFile = mkIf cfg.keyFile "${cfg.dataDir}/keyFile";
          };

          environment = (
            (lib.mapAttrs' (n: v: lib.nameValuePair "PHOTOPRISM_${n}" (toString v))
              (defaultSettings
                // {
                  #HOME = "${cfg.dataDir}";
                  DATABASE_DRIVER = "sqlite";
                  DATABASE_DSN = "${cfg.dataDir}/photoprism.sqlite";
                  STORAGE_PATH = "${cfg.dataDir}/storage";
                  ORIGINALS_PATH = "${cfg.originalsDir}";
                  IMPORT_PATH = "${cfg.dataDir}/import";
                  SIDECAR_PATH = "${cfg.dataDir}/sidecar";
                }
                // cfg.settings)
             ) // { # thsese don't get PHOTOPRISM prepended to them. 
              SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"; # setting to "" prevents photoprism from accessing external https://
            });
        };
      };
  }
