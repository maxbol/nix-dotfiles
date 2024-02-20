{ config, pkgs, ... }:
let
  contactsUuid = "ee85de46-1923-44ff-aa47-1494baa7cc4c";
  khalConfig = import config/khal.nix { contactsUuid = contactsUuid; config = config; };
  khardConfig = import config/khard.nix { contactsUuid = contactsUuid; config = config; };
  vdirsyncerConfig = import config/vdirsyncer.nix { config = config; };
in
{
  home.packages = with pkgs; [
    khal
    khard
  ];

  xdg.configFile = {
    "vdirsyncer/config".text = vdirsyncerConfig;
    "khal/config".text = khalConfig;
    "khard/khard.conf".text = khardConfig;
  };
}