{
  modules = [{
    copper.features = builtins.trace "sets features" [
      /* Common */
      "catppuccin"
      "chroma"
      "cli"
      "fish"
      "git"
      "link-config"
      "nvim"
      "zsh"

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
    # copper.file.symlink.enable = true;

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
  }];
  system = "x86_64-linux";
}
