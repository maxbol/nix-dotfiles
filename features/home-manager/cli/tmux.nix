{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 100000;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
        set -g @catppuccin_flavour 'mocha'
        set -g @catppuccin_window_tabs_enabled on
        set -g @catppuccin_date_time '%H:%M'

        bind-key -n C-0 select-window -t :0
        bind-key -n C-0 select-window -t :1
        bind-key -n C-0 select-window -t :2
        bind-key -n C-0 select-window -t :3
        bind-key -n C-0 select-window -t :4
        bind-key -n C-0 select-window -t :5
        bind-key -n C-0 select-window -t :6
        bind-key -n C-0 select-window -t :7
        bind-key -n C-0 select-window -t :8
        bind-key -n C-0 select-window -t :9

        bind-key -n C-T create-window
        '';
      }
    ];
  };
}
