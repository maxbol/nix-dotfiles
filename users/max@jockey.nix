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
        "browsers"
        "chroma"
        "cli-nixos"
        "cloud-tools"
        "development"
        "direnv"
        "edge"
        "filemanager"
        "floorp"
        "gaming"
        "git"
        "i3"
        "keymapp"
        "media"
        "neovim"
        "nixos/clockify"
        "nixos/clockify-watch"
        "nixos/database-tools"
        "nixos/productivity"
        "nixos/rofi-plugins"
        "nixos/swim"
        "node"
        "postman"
        "rofi-launcher-swwwallselect-patch"
        "security"
        "slack"
        "social"
        "sops"
        "sysadmin"
        "tmux"
        "utils"
        "vscode"
        "hyprland"
        # "nvchad"
        "swaylock-nosuspend"
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
