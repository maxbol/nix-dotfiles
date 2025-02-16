{
  modules = [
    (
      {origin, ...}: {
        # Fix issues with spotlight not finding nix-installed apps
        imports = [
          origin.inputs.mac-app-util.homeManagerModules.default
        ];
      }
    )
    ({
      pkgs,
      lib,
      origin,
      ...
    }: let
      inputsToRegistry = lib.attrsets.mapAttrs (_: input: {
        flake = input;
      });
    in {
      home.stateVersion = "24.05";
      nix.settings.experimental-features = lib.mkForce ["nix-command" "flakes"];

      nix.registry = inputsToRegistry origin.inputs;

      nix.gc = {
        automatic = true;
        frequency = "daily";
        options = "--delete-older-than 30d";
      };

      copper.features = [
        "link-config"
      ];

      maxdots.features = [
        "chroma-darwin"
        "cli-hm"
        "darwin/sketchybar"
        "development"
        "direnv"
        "keycastr"
        "neovim"
        # "neovide"
        "obsidian"
        "zathura"
        "productivity"
        "sops"
        "tmux"
        "tui-browser"
        # "media-tui"
      ];

      nixpkgs.config.permittedInsecurePackages = [
        "electron-25.9.0"
        "freeimage-unstable-2021-11-01"
      ];

      home.packages = with pkgs; [
        tiny
        fastfetch
      ];
    })
  ];
  system = "aarch64-darwin";
}
