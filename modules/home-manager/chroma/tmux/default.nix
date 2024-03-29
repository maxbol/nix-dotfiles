{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.copper.chroma;

  inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;
in {
  options = {
    copper.chroma.tmux.enable = mkOption {
      type = types.bool;
      default = config.programs.rofi.enable;
      example = false;
      description = ''
        Whether to enable tmux theming as part of Chroma.
      '';
    };
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.enable && cfg.tmux.enable) || config.programs.tmux.enable;
        message = "Tmux Chroma integration only works when the base Tmux module is enabled.";
      }
    ];

    copper.chroma.programs.rofi = {
      themeOptions = {
        colorOverrides = mkOption {
          type = with types; attrsOf colorType;
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
        file."theme.rasi" = {
          required = true;

          source = mkDefault (opts.palette.generateDynamic {
            template = ./rofi.rasi.dyn;
            paletteOverrides = config.colorOverrides;
          });
        };

        file."config.rasi".text = ''
          configuration {
            icon-theme: "${opts.desktop.iconTheme.name}";
          }
        '';
      };
    };
  };

  imports = [
    (mkIf (cfg.enable && cfg.rofi.enable) {
      copper.chroma.desktop.enable = true;

      programs.rofi.theme = "${cfg.themeDirectory}/active/rofi/theme.rasi";
      programs.rofi.imports = ["${cfg.themeDirectory}/active/rofi/config.rasi"];
    })
  ];
}
