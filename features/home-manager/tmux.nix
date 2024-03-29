{
  config,
  origin,
  copper,
  maxdots,
  pkgs,
  ...
}:
with pkgs; let
  tmux-sessionx = origin.inputs.tmux-sessionx.packages.${pkgs.system}.default;

  clockify-read-status = "${maxdots.packages.clockify-watch}/bin/clockify-read-status";

  clockify-read-status-wrapped = writeShellScript "clockify-read-status-wrapped" ''
    ${clockify-read-status} ${config.home.homeDirectory}/.clockify-cli.yaml ${config.xdg.cacheHome}
  '';

  # Clockify statusline module for theme_base
  theme-base-module-clockify = writeTextFile {
    name = "theme-base-module-clockify";
    text = ''
      show_clockify() {
        local index=$1
        local icon=$(get_tmux_option "@theme_base_application_icon" "󰥔")
        local color=$(get_tmux_option "@theme_base_application_color" "$thm_pink")
        local text="#( ${clockify-read-status-wrapped} )"

        local module=$( build_status_module "$index" "$icon" "$color" "$text" )

        echo "$module"
      }
    '';
    destination = "/clockify.sh";
    executable = true;
  };

  theme-base-custom-plugins = symlinkJoin {
    name = "theme-base-custom-plugins";
    paths = [
      theme-base-module-clockify
    ];
  };
in {
  featureOptions = with lib; {
    theme = mkOption {
      type = types.str;
    };
  };

  config = {
    copper.file.config."tmux/overrides.conf" = "config/tmux/overrides.conf";

    programs.tmux = {
      enable = true;
      mouse = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "screen-256color";
      historyLimit = 50000;

      resizeAmount = 30;
      baseIndex = 1;
      escapeTime = 0;

      sensibleOnTop = true;

      extraConfig = ''
        source-file ~/.config/tmux/overrides.conf
      '';

      plugins = with pkgs; [
        {
          plugin = maxdots.packages.tmuxplugin-theme-base;
          extraConfig = ''
            set -g @theme_base_theme '${config.maxdots.feature.tmux.theme}'
            set -g @theme_base_window_tabs_enabled on
            set -g @theme_base_date_time '%H:%M'
            set -g @theme_base_window_left_separator ""
            set -g @theme_base_window_right_separator " "
            set -g @theme_base_window_middle_separator " █"
            set -g @theme_base_window_number_position "right"
            set -g @theme_base_window_default_fill "number"
            set -g @theme_base_window_default_text "#W"
            set -g @theme_base_window_current_fill "number"
            set -g @theme_base_window_current_text "#W#{?window_zoomed_flag,(),}"
            set -g @theme_base_status_modules_right "clockify directory date_time"
            set -g @theme_base_status_modules_left "session"
            set -g @theme_base_status_left_separator  " "
            set -g @theme_base_status_right_separator " "
            set -g @theme_base_status_right_separator_inverse "no"
            set -g @theme_base_status_fill "icon"
            set -g @theme_base_status_connect_separator "no"
            set -g @theme_base_directory_text "#{b:pane_current_path}"
            # set -g @theme_base_meetings_text "#($HOME/.config/tmux/scripts/cal.sh)"
            set -g @theme_base_date_time_text "%H:%M"

            set -g @theme_base_custom_plugin_dir "${theme-base-custom-plugins}"
          '';
        }
        {
          plugin = tmuxPlugins.yank;
        }
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
          '';
        }
        {
          plugin = tmuxPlugins.tmux-fzf;
        }
        {
          plugin = tmuxPlugins.fzf-tmux-url;
          extraConfig = ''
            set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
            set -g @fzf-url-history-limit '2000'
          '';
        }
        {
          plugin = tmuxPlugins.vim-tmux-navigator;
        }
        {
          plugin = tmuxPlugins.tmux-thumbs;
        }
        {
          plugin = tmux-sessionx;
          extraConfig = ''
            set -g @sessionx-bind 'C-o'
            set -g @sessionx-x-path '~/dotfiles'
            set -g @sessionx-window-height '85%'
            set -g @sessionx-window-width '75%'
            set -g @sessionx-zoxide-mode 'on'
            set -g @sessionx-filter-current 'false'
            set -g @sessionx-preview-enabled 'true'
            set -g @sessionx-bind-kill-session 'ctrl-y'
          '';
        }
        {
          plugin = maxdots.packages.clockify-tmux;
        }
      ];
    };
  };
}
