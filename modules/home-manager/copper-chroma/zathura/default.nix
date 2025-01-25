{
  lib,
  config,
  ...
}: let
  inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;
  cfg = config.copper.chroma;
in {
  options = {
    copper.chroma.zathura = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.programs.zathura.enable;
        example = false;
        description = ''
          Whether to enable Zathura settings as part of Chroma.
        '';
      };
    };
  };

  config = {
    copper.chroma.programs.zathura = {
      themeOptions = {
        colorOverrides = lib.mkOption {
          type = lib.types.attrsOf colorType;
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
        file."zathurarc" = {
          required = true;
          source = lib.mkDefault (opts.palette.generateDynamic {
            template = ./zathurarc.dyn;
            paletteOverrides = config.colorOverrides;
          });
        };
      };
    };
  };

  imports = [
    (
      lib.mkIf
      (cfg.enable && cfg.zathura.enable)
      {
        programs.zathura = {
          extraConfig = ''
            include ${config.xdg.configHome}/chroma/active/zathura/zathurarc
          '';
        };
      }
    )
  ];
}
