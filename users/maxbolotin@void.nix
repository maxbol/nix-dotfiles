{
  modules = [
    {
      copper.features = [
        "chroma"
        "link-config"
        "wezterm"
      ];

      maxdots.features = [
        "development"
        "nvchad"
        "cli-hm"
        "productivity"
        "direnv"
        "sops"
      ];

      maxdots.feature.tmux = {
        enable = true;
        theme = "/Users/maxbolotin/.config/tmux/theme.tmuxtheme";
      };

      copper.file.config."tmux/theme.tmuxtheme" = "config/tmux/theme.tmuxtheme";

      nixpkgs.config.permittedInsecurePackages = [
        "electron-25.9.0"
        "freeimage-unstable-2021-11-01"
      ];

      # programs.ssh.enable = false;
    }
  ];
  system = "aarch64-darwin";
}
