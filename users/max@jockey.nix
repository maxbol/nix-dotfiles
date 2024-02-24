{
  modules = [{
    #copper.feature.standaloneBase.enable = false;
    #copper.feature.nixosBase.enable = true;

    copper.features = [
      /* Common */
      "chroma"
      "cli"
      "fish"
      "git"
      "link-config"
      "neovim"
      # "zsh"

      /* NixOS specific */
      "nixos/_1password"
      "nixos/dunst"
      "nixos/hyprland"
      "nixos/rofi"
      "nixos/swaylock"
      "nixos/swim"
      "nixos/waybar-hyprdots"
      "nixos/waybar"
      "nixos/wlogout"
    ];
    copper.file.symlink.base = "/home/max/dotfiles";
    copper.file.symlink.enable = true;

    maxdots.features = [
      "azure"
      "calendar"
      "chrome"
      "gaming"
      "git"
      "media"
      "node"
      "productivity"
      "security"
      "slack"
      "utils"
      "vscode"
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
      "freeimage-unstable-2021-11-01"
    ];
  }];
  system = "x86_64-linux";
}
