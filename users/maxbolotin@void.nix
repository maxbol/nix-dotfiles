{
  modules = [{
    copper.features = [
      "chroma"
      "link-config"
      "wezterm"
    ];

    maxdots.features = [
      "nvchad"
      "cli-hm"
      "productivity"
      "direnv"
      "sops"
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
      "freeimage-unstable-2021-11-01"
    ];

    # programs.ssh.enable = false;
  }];
  system = "aarch64-darwin";
}
