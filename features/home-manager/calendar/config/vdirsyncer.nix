{ config, /* lib, sops, */ ... }: /* let
  fetchCommand = command:
    if lib.isList command
    then [ "command" ] ++ command
    else [ "command" "sh" "-c" command ];

  mkDavSection = { type, name, url, username ? null, password ? null }: assert builtins.elem type [ "contacts" "calendar" ]; let
    id = "${type}_${name}";
    basePath = {
      "contacts" = contactsBasePath;
      "calendar" = calendarBasePath;
    }.${type};nixpkgs-staging
  in
  {
    "pair ${id}" = {
      a = "${id}_local";
      b = "${id}_remote";
      collections = [ "from a" "from b" ];
      metadata = [ "displayname" ];
    };

    "storage ${id}_local" = {
      type = "filesystem";
      path = "${basePath}/${name}/";
      fileext = {
        contacts = ".vcf";
        calendar = ".ics";
      }.${type};
    };

    "storage ${id}_remote" = {
      type = {
        "calendar" = "caldav";
        "contacts" = "carddav";
      }.${type};
      inherit url username password;
    };
  };

  mkWebcalSection = { name, url ? null, urlCommand ? null }: assert url == null -> urlCommand != null; {
    "pair calendar_${name}" = {
      a = "calendar_${name}_local";
      b = "calendar_${name}_remote";
      collections = null;
    };

    "storage calendar_${name}_local" = {
      type = "filesystem";
      path = "${calendarBasePath}/${name}/";
      fileext = ".ics";
    };

    "storage calendar_${name}_remote" = {
      type = "http";
    } // (if urlCommand != null then {
      "url.fetch" = fetchCommand urlCommand;
    } else {
      inherit url;
    });
  };
in lib.generators.toINI {
  mkKeyValue = k: v: "${k} = ${builtins.toJSON v}";
}
({
  general = {
    status_path = "${config.xdg.configHome}/vdirsyncer/status";
  };
} // lib.foldl lib.mergeAttrs {} [
  (mkWebcalSection {
    type = "calendar";
    name = "vcs";
    url = "https://outlook.office365.com/owa/calendar/43a1fb8b0a254f669df0ebf9b1097037@volvocars.com/19e96e8d19f24987b2a8348ffb4323042737759542241723415/calendar.ics";
  })
  (mkDavSection {
    type = "calendar";
    name = "personal";
    url = sops.secrets.;
  })
]) */


 ''
[general]
status_path = "${config.xdg.configHome}/vdirsyncer/status/"

[storage contacts_nosync]
type = "filesystem"
path = "~/${config.xdg.dataHome}/contacts/nosync"
fileext = ".vcf"

[pair calendar_vcs]
a = "calendar_vcs_local"
b = "calendar_vcs_remote"
collections = null

[storage calendar_vcs_local]
type = "filesystem"
path = "~/${config.xdg.dataHome}/calendar/vcs"
fileext = ".ics"

[storage calendar_vcs_remote]
type = "http"
url = "https://outlook.office365.com/owa/calendar/43a1fb8b0a254f669df0ebf9b1097037@volvocars.com/19e96e8d19f24987b2a8348ffb4323042737759542241723415/calendar.ics"

[pair calendar_swedish_holidays]
a = "calendar_swedish_holidays_local"
b = "calendar_swedish_holidays_remote"
collections = null


[storage calendar_swedish_holidays_local
type = "filesystem"
path = "~/${config.xdg.dataHome}/calendar/swedish_holidays"
fileext = ".ics"

[storage calendar_swedish_holidays_remote]
type = "http"
url = "https://www.webcal.guru/sv-SE/ladda_ner_kalendern?calendar_instance_id=86"
''
