{
  pkgs,
  maxdots,
  config,
  lib,
  ...
}: let
  cfg = config.programs.tmux-themer;
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
    };
  };

  config = {
    programs.tmux.plugins = [
      {
        plugin = maxdots.packages.tmuxplugin-theme-base;
        extraConfig = ''
          set -g @theme_base_theme '${cfg.theme}'
          set -g @theme_base_window_tabs_enabled on
          set -g @theme_base_date_time '%H:%M'
          set -g @theme_base_window_left_separator ""
          set -g @theme_base_window_right_separator " "
          set -g @theme_base_window_middle_separator " █"
          set -g @theme_base_window_number_position "right"
          set -g @theme_base_window_default_fill "number"
          set -g @theme_base_window_default_text "#{b:pane_current_path}"
          set -g @theme_base_window_current_fill "number"
          set -g @theme_base_window_current_text "#{b:pane_current_path}#{?window_zoomed_flag,(),}"
          set -g @theme_base_status_modules_right "clockify directory date_time"
          set -g @theme_base_status_modules_left "session"
          set -g @theme_base_status_left_separator  " "
          set -g @theme_base_status_right_separator " "
          set -g @theme_base_status_right_separator_inverse "no"
          set -g @theme_base_status_fill "icon"
          set -g @theme_base_status_connect_separator "no"
          set -g @theme_base_directory_text "#{b:pane_current_path}"
          # set -g @theme_base_meetings_text "#($home/.config/tmux/scripts/cal.sh)"
          set -g @theme_base_date_time_text "%H:%M"

          set -g @theme_base_custom_plugin_dir "${cfg.customPluginDir}"
        '';
      }
    ];
  };
}
