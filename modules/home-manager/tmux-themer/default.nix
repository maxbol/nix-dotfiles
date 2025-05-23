{
  pkgs,
  maxdots,
  config,
  lib,
  ...
}: let
  cfg = config.programs.tmux-themer;

  tinted-tmux = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tinted-tmux";
    version = "unstable-2024-10-21";
    rtpFilePath = "tmuxcolors.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "tinted-theming";
      repo = "tinted-tmux";
      rev = "f0e7f7974a6441033eb0a172a0342e96722b4f14";
      hash = "sha256-1ohEFMC23elnl39kxWnjzH1l2DFWWx4DhFNNYDTYt54";
    };
  };
in {
  options = with lib; {
    programs.tmux-themer = {
      enable = mkEnableOption "tmux-themer";
      theme = mkOption {
        type = types.str;
        default = "${maxdots.packages.tmuxplugin-theme-base}/share/tmux-plugins/theme-base/themes/catppuccin-mocha.tmuxtheme";
      };
      customPluginDir = mkOption {
        type = types.str;
      };
      modulesRight = mkOption {
        type = types.str;
        default = "directory date_time";
      };
      modulesLeft = mkOption {
        type = types.str;
        default = "session";
      };
    };
  };

  imports = [
    (lib.mkIf cfg.enable {
      programs.tmux.plugins = [
        {
          plugin = tinted-tmux;
          extraConfig = ''

          '';
        }
        # {
        #   plugin = maxdots.packages.tmuxplugin-theme-base;
        #   extraConfig = ''
        #     set -g @theme_base_theme '${cfg.theme}'
        #     set -g @theme_base_window_tabs_enabled on
        #     set -g @theme_base_date_time '%H:%M'
        #     set -g @theme_base_window_left_separator ""
        #     set -g @theme_base_window_right_separator " "
        #     set -g @theme_base_window_middle_separator " █"
        #     set -g @theme_base_window_number_position "right"
        #     set -g @theme_base_window_default_fill "number"
        #     set -g @theme_base_window_default_text "#{b}"
        #     set -g @theme_base_window_current_fill "number"
        #     set -g @theme_base_window_current_text "#{b:pane_current_path}#{?window_zoomed_flag,(),}"
        #     set -g @theme_base_status_modules_right "${cfg.modulesRight}"
        #     set -g @theme_base_status_modules_left "${cfg.modulesLeft}"
        #     set -g @theme_base_status_left_separator  " "
        #     set -g @theme_base_status_right_separator " "
        #     set -g @theme_base_status_right_separator_inverse "no"
        #     set -g @theme_base_status_fill "icon"
        #     set -g @theme_base_status_connect_separator "no"
        #     set -g @theme_base_directory_text "#{b:pane_current_path}"
        #     # set -g @theme_base_meetings_text "#($home/.config/tmux/scripts/cal.sh)"
        #     set -g @theme_base_date_time_text "%H:%M"
        #
        #     set -g @theme_base_custom_plugin_dir "${cfg.customPluginDir}"
        #   '';
        # }
      ];
    })
  ];
}
