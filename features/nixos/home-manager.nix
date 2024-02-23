{ origin, config, lib, ... }: let 
  inherit (lib.strings) concatStrings hasSuffix removeSuffix;
  inherit (builtins) attrNames listToAttrs map filter;
  inherit (origin.inputs) copper;
  inherit (origin.config.gleaming) autoload basepath;
  inherit (copper.lib) loadHome;

  hostName = config.networking.hostName;
  hostSuffix = concatStrings ["@" hostName];
  hasHostSuffix = hasSuffix hostSuffix;
  removeHostSuffix = removeSuffix hostSuffix;

  homeConfigurations = loadHome {
    dir = basepath + "/users";
    specialArgs = autoload.specialArgs;
    modules = autoload.baseModules.home ++ [
      {
        copper.feature.standaloneBase.enable = lib.mkForce false;
        copper.feature.nixosBase.enable = lib.mkForce true;
      }
    ];
  };

  makeUserAttr = user: {
    name = removeHostSuffix user;
    value = homeConfigurations.${user}.config;
  };

  allUsersWithHost = attrNames homeConfigurations;

  usersForThisHost = filter hasHostSuffix allUsersWithHost;
  users = listToAttrs (map makeUserAttr usersForThisHost);
in {
  home-manager.users = users;
}