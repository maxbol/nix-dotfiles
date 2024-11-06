{
  inputs = {
    # Use the latest nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-23.11";

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
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

    # Spicetify flake for Nix integration
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    tmux-sessionx = {
      url = "github:omerxx/tmux-sessionx";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    nixd = {
      url = "github:nix-community/nixd/release/2.1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
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
      # Lock to 0.13 revision for now
      # url = "github:zigtools/zls?rev=a26718049a8657d4da04c331aeced1697bc7652b";
      url = "github:zigtools/zls";
      # inputs.nixpkgs.follows = "nixpkgs";
      # inputs.zig-overlay.follows = "zig-overlay";
      # inputs.gitignore.follows = "gitignore";
      # inputs.flake-utils.follows = "flake-utils";
    };

    zig2nix.url = "github:Cloudef/zig2nix";

    clockifyd.url = "github:maxbol/clockifyd";
    # clockifyd.inputs.zig2nix.follows = "zig2nix";
    nvim-colorctl.url = "github:maxbol/nvim-colorctl";
    # nvim-colorctl.inputs.zig2nix.follows = "zig2nix";
  };

  outputs = inputs:
    inputs.copper.lib.mkGleamingFlake inputs ./. "maxdots" (flakeModules: {
    });
}
