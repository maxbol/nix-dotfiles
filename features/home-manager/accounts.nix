{ pkgs, config, lib, ... }: let
  inherit (config.sops) secrets;
  mkSecretCmd = secret: [ "${pkgs.coreutils-full}/bin/cat" secret.path ];

  mkKhal = color: {
    inherit color;
    enable = true;
    type = "calendar";
  };

  mkCalendar = color: remote: vdirsyncerOpts: {
    inherit remote;
    khal = mkKhal color;
    local.type = "singlefile";
    local.fileExt = ".ics";
    vdirsyncer = {
      enable = true;
      collections = ["from a" "from b"];
      conflictResolution = "remote wins";
    } // vdirsyncerOpts;
    qcal.enable = true;
  };

  calendarAccounts = {
    personal = mkCalendar "light red" {
      type = "http";
      url = "https://calendar.google.com/calendar/ical/maks.bolotin%40gmail.com/private-a3992d3d8fb1a1ffdc55da1d474e7847/basic.ics";
    } {} // {
      primary = true;
      primaryCollection = "personal";
    };

    ourstudio = mkCalendar "dark red" {
      type = "google_calendar";
    } {
      clientIdCommand = mkSecretCmd secrets.caldav-ourstudio-clientid;
      clientSecretCommand = mkSecretCmd secrets.caldav-ourstudio-clientsecret;
      tokenFile = "${config.xdg.dataHome}/calendarsync/tokens/ourstudio";
    } // {
      primaryCollection = "max@ourstudio.se";
    };

    volvocars = mkCalendar "dark magenta" {
      type = "http";
      url = "https://outlook.office365.com/owa/calendar/43a1fb8b0a254f669df0ebf9b1097037@volvocars.com/567e8bd054654eba99dc28f086c1849912128463754489511048/calendar.ics";
    } {} // {
      primaryCollection = "volvocars";
    };
  };
in {
  accounts = {
    calendar = {
      accounts = calendarAccounts;
      basePath = "${config.xdg.configHome}/calendar";
    };
  };

  programs.vdirsyncer.enable = true;
  programs.khal.enable = true;
  programs.qcal.enable = true;

  services.vdirsyncer = {
    enable = true;
    frequency = "1m";
  };

  home.packages = with pkgs; [
    thunderbird
  ];
}
