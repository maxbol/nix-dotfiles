{
  origin,
  copper,
  pkgs,
  ...
}:
with pkgs; let
  tmux-sessionx = origin.inputs.tmux-sessionx.packages.${pkgs.system}.default;

  clockify-cli = lib.getExe maxdots.packages.clockify-cli;

  clockify_sh = pkgs.writeShellScriptBin "clockify.sh" ''
    function display_current_project() {
      ${clockify-cli} show current -f '{{ .Project.ClientName }} > {{ .Project.Name }}'
    }

    function display_current_duration() {
      ${clockify-cli} show current -D
    }

    function display_current_tags() {
      ${clockify-cli} show current -f '{{ .Tags }}'
    }

    function display_statusline() {
      project=$(display_current_project)
      duration=$(display_current_duration)
      tags=$(display_current_tags)

      echo -n "$project | $duration"
    }

    show_clockify() {
      local index=$1
      local icon=$(get_tmux_option "@catppuccin_application_icon" "󰥔")
      local color=$(get_tmux_option "@catppuccin_application_color" "$thm_pink")
      local text=$(display_statusline)

      local module=$( build_status_module "$index" "$icon" "$color" "$text" )

      echo "$module"
    }
  '';

  catppuccin-custom-plugins = pkgs.symlinkJoin {
    name = "catppuccin-custom-plugins";
    paths = [
      clockify_sh
    ];
  };
in {
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
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_window_tabs_enabled on
          set -g @catppuccin_date_time '%H:%M'
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
          set -g @catppuccin_status_modules_right "clockify directory date_time"
          set -g @catppuccin_status_modules_left "session"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"
          set -g @catppuccin_directory_text "#{b:pane_current_path}"
          set -g @catppuccin_meetings_text "#($HOME/.config/tmux/scripts/cal.sh)"
          set -g @catppuccin_date_time_text "%H:%M"

          set -g @catppuccin_custom_plugin_dir "${catppuccin-custom-plugins}/bin"
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
          set -g @sessionx-bind 'o'
          set -g @sessionx-x-path '~/dotfiles'
          set -g @sessionx-window-height '85%'
          set -g @sessionx-window-width '75%'
          set -g @sessionx-zoxide-mode 'on'
          set -g @sessionx-filter-current 'false'
          set -g @sessionx-preview-enabled 'true'
          set -g @sessionx-bind-kill-session 'ctrl-y'
        '';
      }
    ];
  };
}
