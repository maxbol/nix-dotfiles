{
  config,
  lib,
  pkgs,
  copper,
  origin,
  ...
}:
with lib; let
  cfg = config.copper.chroma;

  inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;
in {
  options = {
    copper.chroma.tmux.enable = mkOption {
      type = types.bool;
      default = config.programs.tmux-themer.enable;
      example = false;
      description = ''
        Whether to enable tmux themeing as part of Chroma.
      '';
    };
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.enable && cfg.tmux.enable) || config.programs.tmux-themer.enable;
        message = "Tmux Chroma integration only works when the tmux-themer module is enabled.";
      }
    ];

    copper.chroma.programs.tmux = {
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
        file."theme.tmuxtheme" = {
          required = true;

          source = mkDefault (opts.palette.generateDynamic {
            template = ./theme.tmuxtheme.dyn;
            paletteOverrides = config.colorOverrides;
          });
        };
      };

      reloadCommand = "${lib.getExe pkgs.tmux} source ~/.config/tmux/tmux.conf";
    };
  };

  imports = [
    (mkIf (cfg.enable && cfg.tmux.enable) {
      programs.tmux-themer.theme = "${cfg.themeDirectory}/active/tmux/theme.tmuxtheme";
    })
  ];
}
