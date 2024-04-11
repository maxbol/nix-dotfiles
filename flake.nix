{
  inputs = {
    # Use the latest nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # nixpkgs-bleeding.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Reference Copper's dotfiles for configuration re-use
    copper.url = "github:Cu3PO42/gleaming-glacier/next";
    # Replace the upstream's nixpkgs with our own, so we don't unnecessarily
    # duplicate dependencies.
    copper.inputs.nixpkgs.follows = "nixpkgs";
    copper.inputs.systems.follows = "systems";

    # Spicetify flake for Nix integration
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tmux-sessionx = {
      url = "github:omerxx/tmux-sessionx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixd = {
      url = "github:nix-community/nixd/release/1.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The Window Manager I use
    hyprland = {
      url = "github:hyprwm/Hyprland";
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

    systems = {
      url = "github:nix-systems/default";
    };
  };

  outputs = inputs:
    inputs.copper.lib.mkGleamingFlake inputs ./. "maxdots" (flakeModules: {
    });
}
