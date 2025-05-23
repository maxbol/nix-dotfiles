{
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;
in {
  options = {
    maxdots.chroma.sketchybar.enable = mkOption {
      type = types.bool;
      # default = false;
      default = pkgs.stdenv.hostPlatform.isDarwin;
      example = false;
      description = ''
        Whether to enable Chroma theming for Sketchybar.
      '';
    };
  };

  config = {
    maxdots.chroma.programs.sketchybar = {
      themeOptions = {
        colorOverrides = mkOption {
          type = types.attrsOf colorType;
          default = {};
          description = ''
            Color overrides to apply to the palette-generated theme.
          '';
        };
      };

      themeConfig = {
        config,
        opts,
        ...
      }: {
        file."colors.sh" = {
          required = true;
          source = mkDefault (opts.palette.generateDynamic {
            template = ./colors.sh.dyn;
            paletteOverrides = config.colorOverrides;
          });
        };
      };

      reloadCommand = "sh -c 'sketchybar --reload'";
    };
  };
}
