{
  modules = [
    {
      #copper.feature.standaloneBase.enable = false;
      #copper.feature.nixosBase.enable = true;
      nix.settings.netrc-file = "/home/max/.netrc";

      copper.features = [
        /*
        Common
        */
        "link-config"
        #"neovim"

        /*
        NixOS specific
        */
        "nixos/_1password"
        "nixos/dunst"
        "nixos/rofi"
        "nixos/waybar-hyprdots"
        "nixos/waybar"
        "nixos/wlogout"
      ];
      copper.file.symlink.base = "/home/max/dotfiles";
      copper.file.symlink.enable = true;

      maxdots.features = [
        "accounts"
        "azure"
        "chroma"
        "chrome"
        "cli-nixos"
        "development"
        "direnv"
        "edge"
        "filemanager"
        "floorp"
        "gaming"
        "git"
        "hyprland"
        "media"
        "nixos/clockify"
        "nixos/clockify-watch"
        "nixos/productivity"
        "nixos/rofi-plugins"
        "nixos/swim"
        "nixos/tableplus"
        "node"
        "nvchad"
        "postman"
        "rofi-launcher-swwwallselect-patch"
        "security"
        "slack"
        "social"
        "sops"
        "swaylock-nosuspend"
        "tmux"
        "utils"
        "vscode"
      ];

      nixpkgs.config.permittedInsecurePackages = [
        "electron-25.9.0"
        "freeimage-unstable-2021-11-01"
        "electron-24.8.6"
      ];
    }
  ];
  system = "x86_64-linux";
}
