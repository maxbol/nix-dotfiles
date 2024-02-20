{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vdirsyncer
  ];

  systemd.services."vdirsyncer" = {
    description = "Synchronize calendars and contacts";
    startLimitBurst = 2;
    serviceConfig = {
      ExecStart = ''${pkgs.vdirsyncer}/bin/vdirsyncer sync'';
      RunTimeMaxSec = "3m";
      Restart = "on-failure";
    };
  };

  systemd.timers."vdirsyncer" = {
    description = "Synchronize vdirs";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "15m";
      AccuracySec = "5m";
    };
  };
}