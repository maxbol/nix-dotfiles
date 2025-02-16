{pkgs, ...}: let
  pkgs-patched = pkgs.extend (final: prev: rec {
    gtk3 = pkgs.gtk3.overrideAttrs (oldAttrs: {
      patches =
        oldAttrs.patches
        ++ [
          ./patches/gtk3-quartz-borderless.patch
        ];
    });

    girara = (pkgs.girara.override {gtk = gtk3;}).overrideAttrs (oldAttrs: {
      patches = [
        ./patches/girara-set-decorated.patch
      ];
    });
  });
in
  pkgs-patched.zathura
