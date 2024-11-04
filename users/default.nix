{
  home-manager,
  nixpkgs,
  lib,
  ...
}: let
  mkUser = {
    username,
    system,
    modules,
    extraSpecialArgs ? {},
  }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules =
        modules
        ++ [
          {
            home.username = lib.mkDefault username;
          }
        ];
      extraSpecialArgs = extraSpecialArgs;
    };
in [
  mkUser
  {
    username = "maxbolotin";
    system = "aarch64-darwin";
    modules = [
      (import
        "./maxbolotin@void.nix")
      # (
      #   import
      #   "./max@jockey.nix"
      # )
    ];
  }
]
