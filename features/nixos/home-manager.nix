{ origin, config, lib, hmSpecialArgs, hmBaseModules, ... }: let 
  inherit (lib.strings) concatStrings hasSuffix removeSuffix splitString;
  inherit (builtins) attrNames listToAttrs map filter foldl';
  inherit (origin.inputs) copper nixpkgs;
  inherit (origin.config.gleaming) basepath;
  inherit (copper.lib) loadDir;
  inherit (copper.inputs) home-manager;

  hostName = config.networking.hostName;
  hostSuffix = concatStrings ["@" hostName];
  hasHostSuffix = hasSuffix hostSuffix;
  removeHostSuffix = removeSuffix hostSuffix;

  foldUserSettings = modules: foldl' (acc: elem: acc // elem) {} modules;

  loadUsers = dir: loadDir dir ({
    path,
    name,
    ...
  }: let
    user = import path;
    username = builtins.elemAt (splitString "@" name) 0;
    modules' = [
        {
          home.username = lib.mkDefault username;
          copper.feature.standaloneBase.enable = false;
          copper.feature.nixosBase.enable = true;
        }
      ]
      ++ user.modules or [];
  in foldUserSettings modules');

  allUsers = loadUsers (basepath + "/users");

  makeUserAttr = user: {
    name = removeHostSuffix user;
    value = allUsers.${user};
  };

  allUsersWithHost = attrNames allUsers;

  usersForThisHost = filter hasHostSuffix allUsersWithHost;
  users = listToAttrs (map makeUserAttr usersForThisHost);
in {
  imports = [
    home-manager.nixosModules.home-manager
  ];

  # Use the same nixpkgs as the system config
  home-manager.useGlobalPkgs = false;
  # Store user packages in $HOME
  home-manager.useUserPackages = false;
  # TODO: this is an extremely ad-hoc solution. could we inject the whole Flake config instead?
  home-manager.extraSpecialArgs = hmSpecialArgs;

  home-manager.sharedModules =
    hmBaseModules
    ++ [{
      copper.feature.nixosBase.enable = lib.mkDefault true;
      copper.feature.standaloneBase.enable = false;
    }];

  #home-manager.users = users;
}
