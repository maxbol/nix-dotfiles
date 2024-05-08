{
  modules = [
    {
      copper.features = [
        "link-config"
        "wezterm"
      ];

      maxdots.features = [
        "chroma-darwin"
        "cli-hm"
        "development"
        "direnv"
        "neovim"
        "productivity"
        "sops"
        "tmux"
      ];

      nixpkgs.config.permittedInsecurePackages = [
        "electron-25.9.0"
        "freeimage-unstable-2021-11-01"
      ];

      # programs.ssh.enable = false;
    }
  ];
  system = "aarch64-darwin";
}
