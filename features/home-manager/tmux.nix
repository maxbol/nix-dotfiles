{
  config,
  origin,
  maxdots,
  pkgs,
  ...
}: let
  clockifyd = origin.inputs.clockifyd.packages.${pkgs.system}.default;

  kube-tmux = pkgs.fetchFromGitHub {
    owner = "jonmosco";
    repo = "kube-tmux";
    rev = "c127fc2181722c93a389534549a217aef12db288";
    sha256 = "sha256-PnPj2942Y+K4PF+GH6A6SJC0fkWU8/VjZdLuPlEYY7A=";
  };

  usr = config.home.username;
  resurrectDirPath = "~/.tmux/resurrect/";
in {
  copper.file.config."tmux/overrides.conf" = "config/tmux/overrides.conf";

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
      set -gq @tinted-tmux-modulepane-right-outer "󱃾 #( KUBE_TMUX_NS_ENABLE=false KUBE_TMUX_SYMBOL_ENABLE=false ${kube-tmux}/kube.tmux )"
      set -gqa @tinted-tmux-modulepane-right-outer "  "
      set -gqa @tinted-tmux-modulepane-right-outer "󰥔 #( ${clockifyd}/bin/clockifyd-get-current )"
      set -gqF @tinted-tmux-modulepane-right-inner "%H:%M"

      source-file ~/.config/tmux/overrides.conf
      source ~/.config/chroma/active/tmux/tinted-tmux-statusline.conf
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
          plugin = tmuxPlugins.vim-tmux-navigator;
          extraConfig = ''
            set -g @vim_navigator_mapping_left "C-Left C-h"  # use C-h and C-Left
            set -g @vim_navigator_mapping_right "C-Right C-l"
            set -g @vim_navigator_mapping_up "C-k"
            set -g @vim_navigator_mapping_down "C-j"
            set -g @vim_navigator_mapping_prev ""  # removes the C-\ binding
          '';
        }
        {
          plugin = tmuxPlugins.session-wizard;
          extraConfig = ''
            set -g @session-wizard 'C-o'
          '';
        }
      ])
      ++ [
        {
          plugin = maxdots.packages.clockify-tmux;
        }
      ];
  };
}
