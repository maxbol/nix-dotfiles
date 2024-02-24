{ origin, config, lib, hmSpecialArgs, hmBaseModules, ... }: let 
  inherit (lib.strings) concatStrings hasSuffix removeSuffix splitString;
  inherit (builtins) attrNames listToAttrs map filter;
  inherit (origin.inputs) copper nixpkgs;
  inherit (origin.config.gleaming) autoload basepath;
  inherit (copper.lib) loadDir;
  inherit (copper.inputs) home-manager;

  hostName = config.networking.hostName;
  hostSuffix = concatStrings ["@" hostName];
  hasHostSuffix = hasSuffix hostSuffix;
  removeHostSuffix = removeSuffix hostSuffix;

  /* homeConfigurations = loadHome {
    dir = basepath + "/users";
    specialArgs = autoload.specialArgs;
    modules = autoload.baseModules.home ++ [
      {
        copper.feature.standaloneBase.enable = false;
        copper.feature.nixosBase.enable = true;
      }
    ];
  }; */

  loadHome = dir: loadDir dir ({
    path,
    name,
    ...
  }: let
    user = import path;
    username = builtins.elemAt (splitString "@" name) 0;
    modules' = [
        ({lib, ...}: {
          home.username = lib.mkDefault username;
          home.stateVersion = "22.11";
        })
      ]
      ++ user.modules or [];
  in
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${user.system};
      modules = modules';
      extraSpecialArgs = autoload.specialArgs;
    });

  homeConfigurations = lib.debug.traceVal (loadHome (basepath + "/users"));

  makeUserAttr = user: {
    name = removeHostSuffix user;
    value = homeConfigurations.${user}.config;
  };

  allUsersWithHost = attrNames homeConfigurations;

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
    (lib.debug.traceVal hmBaseModules)
    ++ [{
      copper.feature.nixosBase.enable = lib.mkDefault true;
      copper.feature.standaloneBase.enable = false;
    }];

  home-manager.users = users;
  
}