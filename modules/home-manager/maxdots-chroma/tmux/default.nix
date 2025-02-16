{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.maxdots.chroma;

  inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;
in {
  options = {
    maxdots.chroma.tmux.enable = mkOption {
      type = types.bool;
      default = config.programs.tmux.enable;
      example = false;
      description = ''
        Whether to enable tmux themeing as part of Chroma.
      '';
    };
  };

  config = {
    assertions = [
      {
        assertion = !cfg.enable || config.programs.tmux.enable;
        message = "Tmux Chroma integration only works when the tmux home-manager module is enabled.";
      }
    ];

    maxdots.chroma.programs.tmux = {
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
        file."tinted-tmux-statusline.conf" = {
          required = true;
          source = mkDefault (opts.palette.generateDynamic {
            template = ./tinted-tmux-statusline.conf.dyn;
            paletteOverrides = config.colorOverrides;
          });
        };
      };

      reloadCommand = "${lib.getExe pkgs.tmux} source ~/.config/tmux/tmux.conf";
    };
  };

  imports = [
    (mkIf (cfg.enable && cfg.tmux.enable) {
      programs.tmux.plugins = [
        {
          # https://github.com/nix-community/home-manager/issues/5952
          plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
            pluginName = "loadtheme";
            version = "1";
            src = pkgs.writeTextFile {
              name = "loadtheme";
              destination = "/loadtheme.tmux";
              executable = true;
              text = '''';
            };
          };
          extraConfig = ''
            source ~/.config/chroma/active/tmux/tinted-tmux-statusline.conf
          '';
        }
      ];
    })
  ];
}
