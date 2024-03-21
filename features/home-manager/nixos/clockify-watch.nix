{
  maxdots,
  config,
  ...
}: let
  clockify-store-status = "${maxdots.packages.clockify-watch}/bin/clockify-store-status";
in {
  systemd.user.services."clockify-store-status" = {
    Unit = {
      Description = "Clockify store status";
    };

    Service = {
      ExecStart = "${clockify-store-status} ${config.home.homeDirectory}/.clockify-cli.yaml ${config.xdg.cacheHome}";
      Restart = "on-failure";
    };
  };

  systemd.user.timers."clockify-store-status" = {
    Unit = {
      Description = "Clockify store status";
    };

    Timer = {
      OnBootSec = "1s";
      OnUnitActiveSec = "1s";
      AccuracySec = "1s";
    };

    Install = {
      WantedBy = ["timers.target"];
    };
  };
}
