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
        local color=$(get_tmux_option "@theme_base_application_color" "$thm_accent3")
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
  copper.file.config."tmux/overrides.conf" = "config/tmux/overrides.conf";

  programs.tmux-themer = {
    enable = true;
    customPluginDir = "${theme-base-custom-plugins}";
  };

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
}
