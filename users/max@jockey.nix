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
        "nixos/swim"
        "nixos/waybar-hyprdots"
        "nixos/waybar"
        "nixos/wlogout"
      ];
      copper.file.symlink.base = "/home/max/dotfiles";
      copper.file.symlink.enable = true;

      maxdots.features = [
        "accounts"
        "azure"
        "chrome"
        "chroma"
        "cli-nixos"
        "nixos/clockify-watch"
        "development"
        "direnv"
        "edge"
        "filemanager"
        "gaming"
        "git"
        "hyprland"
        "media"
        "node"
        "nvchad"
        "nixos/productivity"
        "nixos/rofi-plugins"
        "nixos/tableplus"
        "postman"
        "rofi-launcher-swwwallselect-patch"
        "security"
        "slack"
        "social"
        "sops"
        "swaylock-nosuspend"
        "utils"
        "vscode"
      ];

      nixpkgs.config.permittedInsecurePackages = [
        "electron-25.9.0"
        "freeimage-unstable-2021-11-01"
      ];
    }
  ];
  system = "x86_64-linux";
}
