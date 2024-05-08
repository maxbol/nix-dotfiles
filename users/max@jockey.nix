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
        "azure"
        "browsers"
        "chroma"
        "cli-nixos"
        "development"
        "direnv"
        "edge"
        "filemanager"
        "floorp"
        "gaming"
        "git"
        "hyprland"
        "keymapp"
        "media"
        "neovim"
        "nixos/clockify"
        "nixos/clockify-watch"
        "nixos/productivity"
        "nixos/rofi-plugins"
        "nixos/swim"
        "nixos/tableplus"
        "node"
        "postman"
        "rofi-launcher-swwwallselect-patch"
        "security"
        "slack"
        "social"
        "sops"
        "swaylock-nosuspend"
        "sysadmin"
        "tmux"
        "utils"
        "vscode"
        # "nvchad"
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
