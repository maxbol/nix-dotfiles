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
        '';
      }
    ];
  };
}
