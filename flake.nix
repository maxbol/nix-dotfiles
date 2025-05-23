{
  inputs = {
    # Use the latest nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.gitignore.follows = "gitignore";
      inputs.flake-compat.follows = "flake-compat";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    # Only for deduplication of other transitive dependencies
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    systems = {
      url = "github:nix-systems/default";
    };

    systems-linux = {
      url = "github:nix-systems/default-linux";
    };

    # Reference Copper's dotfiles for configuration re-use
    # Replace the upstream's nixpkgs with our own, so we don't unnecessarily
    # duplicate dependencies.
    copper = {
      url = "github:Cu3PO42/gleaming-glacier/next";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
        hyprland.follows = "hyprland";
        hyprland-plugins.follows = "hyprland-plugins";
        hypr-contrib.follows = "hypr-contrib";
      };
    };

    # Utility to fix issues with spotlight not finding nix-installed apps
    mac-app-util.url = "github:hraban/mac-app-util";

    # Spicetify flake for Nix integration
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # textfox.url = "github:maxbol/textfox/?rev=7e24bdc1ea35a858ee25f2e8e868265a1919af13";
    textfox.url = "github:maxbol/textfox/copy-on-activation-mode@allow-custom-css@flatten-css";
    # textfox.url = "git+file:///Users/maxbolotin/Source/textfox?ref=copy-on-activation-mode@allow-custom-css&shallow=1";
    # textfox.url = "github:maxbol/textfox/allow-custom-include-in-configcss";

    nur.url = "github:nix-community/NUR";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The Window Manager I use
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    custom-udev-rules.url = "github:MalteT/custom-udev-rules";

    # devenv = {
    #   url = "github:cachix/devenv";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      # inputs.nixpkgs.follows = "nixpkgs";
      # inputs.flake-compat.follows = "flake-compat";
      # inputs.flake-utils.follows = "flake-utils";
    };

    zls = {
      # 0.14
      url = "github:zigtools/zls";
      # inputs.zig-overlay.follows = "zig-overlay";
      # Lock to 0.13 revision for now
      # url = "github:zigtools/zls?rev=a26718049a8657d4da04c331aeced1697bc7652b";
      # inputs.nixpkgs.follows = "nixpkgs";
      # inputs.gitignore.follows = "gitignore";
      # inputs.flake-utils.follows = "flake-utils";
    };

    clockifyd.url = "github:maxbol/clockifyd";
    nvim-colorctl.url = "github:maxbol/nvim-colorctl/log-the-shit-out-of-the-filenotfound-error";
    obsidian-remote.url = "github:maxbol/obsidian-remote";
  };

  outputs = inputs:
    inputs.copper.lib.mkGleamingFlake inputs ./. "maxdots" (flakeModules: {
      perSystem = {system, ...}: {
        # https://github.com/NixOS/nixpkgs/issues/402079
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              nodejs = prev.nodejs_22;
              nodejs-slim = prev.nodejs-slim_22;

              nodejs_20 = prev.nodejs_22;
              nodejs-slim_20 = prev.nodejs-slim_22;
            })
          ];
        };
      };
    });
}
