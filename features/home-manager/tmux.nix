{
  config,
  origin,
  maxdots,
  pkgs,
  ...
}: let
  tmux-sessionx = origin.inputs.tmux-sessionx.packages.${pkgs.system}.default;
  clockifyd = origin.inputs.clockifyd.packages.${pkgs.system}.default;

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
        local text="#( ${clockifyd}/bin/clockifyd-get-current )"

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
    # modulesRight = "kube date_time";
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    # shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    historyLimit = 50000;

    resizeAmount = 30;
    baseIndex = 1;
    escapeTime = 0;

    sensibleOnTop = true;

    extraConfig = ''
      # https://github.com/nix-community/home-manager/issues/5952
      # set -gu default-command
      # set -g default-shell "$SHELL"
      source-file ~/.config/tmux/overrides.conf
    '';

    plugins =
      (with pkgs; [
        {
          # https://github.com/nix-community/home-manager/issues/5952
          plugin = tmuxPlugins.mkTmuxPlugin {
            pluginName = "nix-shellfix";
            version = "1";
            src = writeTextFile {
              name = "nix-shellfix-plugin";
              destination = "/nix_shellfix.tmux";
              executable = true;
              text = '''';
            };
          };
          extraConfig = ''
            set -gu default-command
            set -g default-shell "$SHELL"
          '';
        }
        {
          plugin = tmuxPlugins.yank;
        }
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g allow-passthrough on
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'

            set -g @resurrect-capture-pane-contents 'on'

            set -g @resurrect-dir ${resurrectDirPath}
            # set -g @resurrect-hook-post-save-all 'sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/${usr}/bin/||g; s|/home/${usr}/.nix-profile/bin/||g" ${resurrectDirPath}/last | sponge ${resurrectDirPath}/last'
            set -g @resurrect-hook-post-save-all "sed 's/--cmd[^ ]* [^ ]* [^ ]*//g; s|' $resurrect_dir/last | sponge $resurrect_dir/last"
            set -g @resurrect-processes '"~htop->htop" "~nv->nv" "~ranger->ranger" "~less->less" "~bat->bat" "~man->man" "~yazi->yazi"'
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
          # plugin = tmuxPlugins.mkTmuxPlugin {
          #   pluginName = "vim-tmux-navigator";
          #   rtpFilePath = "vim-tmux-navigator.tmux";
          #   version = "unstable-2022-08-21";
          #   src = fetchFromGitHub {
          #     owner = "maxbol";
          #     repo = "vim-tmux-navigator";
          #     rev = "8cc0ac7cf9f2d28aa9a696a93cee8e70c0395b15";
          #     hash = "sha256-WoKS+aHcJL03IwVbDJtBEqPa9kNbccg01bkYTSq0B1U=";
          #   };
          # };

          plugin = tmuxPlugins.vim-tmux-navigator;
          extraConfig = ''
            set -g @vim_navigator_mapping_left "C-Left C-h"  # use C-h and C-Left
            set -g @vim_navigator_mapping_right "C-Right C-l"
            set -g @vim_navigator_mapping_up "C-k"
            set -g @vim_navigator_mapping_down "C-j"
            set -g @vim_navigator_mapping_prev ""  # removes the C-\ binding
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
            set -g @sessionx-bind-kill-session 'ctrl-q'
          '';
        }
        {
          plugin = maxdots.packages.clockify-tmux;
        }
      ];
  };
}
