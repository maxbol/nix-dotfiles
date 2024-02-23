{ config, lib, ... }: let 
  hostName = config.networking.hostName;
  inherit (lib.strings) concatStrings;
  inherit (lib.lists) forEach;
  userDir = userName: concatStrings [userName "@" hostName];

  allUsers = [
    "max"
  ];
in {
  home-manager.users = builtins.listToAttrs (
    forEach allUsers (user: rec {
      key = userDir user;
      value = import (builtins.toPath (concatStrings "../../users" key));
    })
  );
}