{...}: {
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     tracy = prev.tracy.overrideAttrs (old: rec {
  #       version = "0.11.1";
  #
  #       src = final.fetchFromGitHub {
  #         owner = "wolfpld";
  #         repo = "tracy";
  #         rev = "v${version}";
  #         hash = "sha256-HofqYJT1srDJ6Y1f18h7xtAbI/Gvvz0t9f0wBNnOZK8=";
  #       };
  #     });
  #   })
  # ];
}
