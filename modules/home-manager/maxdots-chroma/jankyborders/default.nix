{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;

  cfg = config.maxdots.chroma;
in {
  options = {
    maxdots.chroma.jankyborders = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = false;
        description = ''
          Whether to enable Jankyborders themeing as part of Chroma.
        '';
      };
    };
  };

  config = {
    maxdots.chroma.programs.jankyborders = {
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
        file."bordersrc" = {
          required = true;
          source = opts.palette.generateDynamic {
            template = ./bordersrc.dyn;
            paletteOverrides = config.colorOverrides;
            executable = true;
          };
        };
      };

      reloadCommand = "killall borders";
    };
  };

  imports = [
    (
      lib.mkIf
      (cfg.enable && cfg.jankyborders.enable)
      {
        xdg.configFile."borders/bordersrc".source = config.lib.file.mkOutOfStoreSymlink "${config.maxdots.chroma.themeDirectory}/active/jankyborders/bordersrc";
      }
    )
  ];
}
