{ sops, ... }: let
  mkSecretCmd = { path, ... }: [ "cat" path ];

  mkKhal = color: {
    inherit color;
    enable = true;
    type = "calendar";
  };

  mkCalendar = color: remote: {
    inherit remote;
    khal = mkKhal color;
    local.type = "filesystem";
    vdirsyncer.enable = true;
  };

  accountSecrets = sops.secrets.accounts;
  calSecrets = accountSecrets.calendar;
  emailSecrets = emailSecrets.email;

  calendarAccounts = {
    personal = mkCalendar "light red" {
      type = "http";
      url = calSecrets.ical_personal;
    } // {
      primary = true;
    };

    ourstudio = mkCalendar = "dark red" {
      type = "http";
      url = calSecrets.ical_ourstudio;
    };

    volvocars = mkCalendar "dark magenta" {
      type = "http";
      url = calSecrets.ical_volvocars;
    };
  };
in {
  accounts = {
    calendar.accounts = calendarAccounts;
  };
}
