import ./make-test-python.nix ({ lib, pkgs, ... }:

let
  user = "someuser";
  password = "some_password";
  port = "5232";
  filesystem_folder = "/data/radicale";

  cli = "${lib.getExe pkgs.calendar-cli} --caldav-user ${user} --caldav-pass ${password}";
in {
  name = "radicale3";
  meta.maintainers = with lib.maintainers; [ dotlambda jcumming ];

  nodes.machine = { pkgs, ... }: {
    services.radicale = {
      enable = true;
      package = pkgs.radicale.overrideAttrs (old: {
        propagatedBuildInputs = old.propagatedBuildInputs ++ [pkgs.python3Packages.radicale_remind pkgs.remind];
      });
      
      settings = {
        auth = {
          type = "htpasswd";
          htpasswd_filename = "/etc/radicale/users";
          htpasswd_encryption = "bcrypt";
        };
        storage = {
          inherit filesystem_folder;
          type = "radicale_remind";
          remind_file = filesystem_folder + "/remind";
        };
        logging.level = "debug";
      };
      rights = {
        principal = {
          user = ".+";
          collection = "{user}";
          permissions = "RW";
        };
        calendars = {
          user = ".+";
          collection = "{user}/[^/]+";
          permissions = "rw";
        };
      };
    };
    systemd.tmpfiles.rules = [ "d ${filesystem_folder} 0750 radicale radicale -" ];
    # WARNING: DON'T DO THIS IN PRODUCTION!
    # This puts unhashed secrets directly into the Nix store for ease of testing.
    environment.etc."radicale/users".source = pkgs.runCommand "htpasswd" {} ''
      ${pkgs.apacheHttpd}/bin/htpasswd -bcB "$out" ${user} ${password}
    '';
    environment.systemPackages = [ pkgs.remind ];  
  };
  testScript = ''
    # create a dummy entry
    machine.succeed("date +'REM %b %d %Y AT %H:%M MSG %%reminders generated%%' > ${filesystem_folder}/now")
    machine.succeed("remind ${filesystem_folder}/now")

    machine.wait_for_unit("radicale.service")
    machine.wait_for_open_port(${port})

    machine.succeed(
        "${cli} --caldav-url http://localhost:${port}/${user} calendar agenda"
    )

    with subtest("Test rights file"):
        machine.fail(
            "${cli} --caldav-url http://localhost:${port}/${user} calendar create sub/cal"
        )
        machine.fail(
            "${cli} --caldav-url http://localhost:${port}/otheruser calendar create cal"
        )

    with subtest("Test web interface"):
        machine.succeed("curl --fail http://${user}:${password}@localhost:${port}/.web/")

    with subtest("Test security"):
        output = machine.succeed("systemd-analyze security radicale.service")
        machine.log(output)
        assert output[-9:-1] == "SAFE :-}"
  '';
})
