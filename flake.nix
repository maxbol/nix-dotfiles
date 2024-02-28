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

    # Spicetify flake for Nix integration
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.copper.lib.mkGleamingFlake inputs ./. "maxdots" (flakeModules: {
  });
}
