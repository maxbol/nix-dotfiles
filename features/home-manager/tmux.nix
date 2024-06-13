{
  config,
  origin,
  maxdots,
  pkgs,
  ...
}: let
  tmux-sessionx = origin.inputs.tmux-sessionx.packages.${pkgs.system}.default;

  clockify-read-status = "${maxdots.packages.clockify-watch}/bin/clockify-read-status";

  clockify-read-status-wrapped = pkgs.writeShellScript "clockify-read-status-wrapped" ''
    ${clockify-read-status} ${config.home.homeDirectory}/.clockify-cli.yaml ${config.xdg.cacheHome}
  '';

  kube-tmux = pkgs.fetchFromGitHub {
    owner = "jonmosco";
    repo = "kube-tmux";
    rev = "c127fc2181722c93a389534549a217aef12db288";
    sha256 = "sha256-PnPj2942Y+K4PF+GH6A6SJC0fkWU8/VjZdLuPlEYY7A=";
  };

  theme-base-module-kube = pkgs.writeTextFile {
    name = "theme-base-module-kube";
    text = ''
      show_kube() {
        local index=$1
        local icon=$(get_tmux_option "@theme_base_application_icon" "󱃾")
        local color=$(get_tmux_option "@theme_base_application_color" "$thm_accent1")
        local text="#( KUBE_TMUX_NS_ENABLE=false KUBE_TMUX_SYMBOL_ENABLE=false ${kube-tmux}/kube.tmux )"

        local module=$( build_status_module "$index" "$icon" "$color" "$text" )

        echo "$module"
      }
    '';
    destination = "/kube.sh";
    executable = true;
  };

  # Clockify statusline module for theme_base
  theme-base-module-clockify = pkgs.writeTextFile {
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

  theme-base-custom-plugins = pkgs.symlinkJoin {
    name = "theme-base-custom-plugins";
    paths = [
      theme-base-module-clockify
      theme-base-module-kube
    ];
  };

  usr = config.home.username;
  resurrectDirPath = "~/.tmux/resurrect/";
in {
  copper.file.config."tmux/overrides.conf" = "config/tmux/overrides.conf";

  # systemd.user.services."tmux-master" = {
  #   Unit = {
  #     Description = "Tmux master service";
  #   };
  #
  #   Service = {
  #     Type = "forking";
  #     ExecStart = "${pkgs.tmux}/bin/tmux new-session -s master -d";
  #     ExecStop = "${pkgs.tmux}/bin/tmux kill-session -t master";
  #   };
  #
  #   Install = {
  #     WantedBy = ["multi-user.target"];
  #   };
  # };
  #
  # systemd.user.services."tmux-scratch" = {
  #   Unit = {
  #     Description = "Tmux scratchpad service";
  #     PartOf = "tmux-master.service";
  #     After = "tmux-master.service";
  #   };
  #
  #   Service = {
  #     Type = "oneshot";
  #     RemainAfterExit = "yes";
  #     ExecStart = "${pkgs.tmux}/bin/tmux new-session -s scratch -d";
  #     ExecStop = "${pkgs.tmux}/bin/tmux kill-session -t scratch";
  #   };
  #
  #   Install = {
  #     WantedBy = ["multi-user.target"];
  #   };
  # };

  programs.tmux-themer = {
    enable = true;
    customPluginDir = "${theme-base-custom-plugins}";
    modulesRight = "kube clockify date_time";
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

    plugins =
      (with pkgs; [
        {
          plugin = tmuxPlugins.yank;
        }
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @allow-passthrough on
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'

            set -g @resurrect-capture-pane-contents 'on'

            set -g @resurrect-dir ${resurrectDirPath}
            # set -g @resurrect-hook-post-save-all 'sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/${usr}/bin/||g; s|/home/${usr}/.nix-profile/bin/||g" ${resurrectDirPath}/last | sponge ${resurrectDirPath}/last'
            set -g @resurrect-hook-post-save-all "sed 's/--cmd[^ ]* [^ ]* [^ ]*//g; s|' $resurrect_dir/last | sponge $resurrect_dir/last"
            set -g @resurrect-processes '"~htop->htop" "~nv->nv" "~ranger->ranger" "~less->less" "~bat->bat"'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-boot 'on'
            set -g @continuum-boot-options 'kitty'
            set -g @continuum-save-interval '5'
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
          plugin = tmuxPlugins.tmux-thumbs;
        }
        {
          plugin = tmuxPlugins.vim-tmux-navigator;
          extraConfig = ''
            # Smart pane switching with awareness of Vim splits.
            # See: https://github.com/christoomey/vim-tmux-navigator
            is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
                | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
            bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
            bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
            bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
            bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
            tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
            if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
                "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
            if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
                "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

            bind-key -T copy-mode-vi 'C-h' select-pane -L
            bind-key -T copy-mode-vi 'C-j' select-pane -D
            bind-key -T copy-mode-vi 'C-k' select-pane -U
            bind-key -T copy-mode-vi 'C-l' select-pane -R
            bind-key -T copy-mode-vi 'C-\' select-pane -l
          '';
        }
      ])
      ++ [
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
