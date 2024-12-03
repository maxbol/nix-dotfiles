{
  config,
  lib,
  pkgs,
  # copper,
  # origin,
  ...
}:
with lib; let
  cfg = config.copper.chroma;

  # tinted-tmux = pkgs.tmuxPlugins.mkTmuxPlugin {
  #   pluginName = "tinted-tmux";
  #   version = "unstable-2024-10-21";
  #   rtpFilePath = "tmuxcolors.tmux";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "tinted-theming";
  #     repo = "tinted-tmux";
  #     rev = "f0e7f7974a6441033eb0a172a0342e96722b4f14";
  #     hash = "sha256-1ohEFMC23elnl39kxWnjzH1l2DFWWx4DhFNNYDTYt54";
  #   };
  # };

  inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;
in {
  options = {
    copper.chroma.tmux.enable = mkOption {
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

    copper.chroma.programs.tmux = {
      themeOptions = {
        # tintThemeName = mkOption {
        #   type = types.str;
        #   default = "base16-default-dark";
        # };
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
        # file."tinted-tmux-settheme.conf" = {
        #   required = true;
        #   source = pkgs.writeText "tinted-tmux-settheme.conf" ''
        #     set -g @tinted-color '${config.tintThemeName}';
        #   '';
        # };
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
