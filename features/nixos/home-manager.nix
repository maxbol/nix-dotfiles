{ config, lib, ... }: let 
  hostName = config.networking.hostName;
  inherit (lib.strings) concatStrings;
  inherit (lib.lists) forEach;
  userDir = userName: concatStrings [userName "@" hostName];

  allUsers = [
    "max"
  ];

  users = builtins.listToAttrs (
    forEach allUsers (user: rec {
      name = userDir user;
      value = import (./. + (concatStrings ["../../../users/" name ".nix"]));
    })
  );
in {
  home-manager.users = users;
}