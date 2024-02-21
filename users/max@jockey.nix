{
  modules = [{
    copper.features = [
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
    copper.file.symlink.enable = true;

    maxdots.features = [
      "calendar"
      "vscode"
      "azure"
      "chrome"
      "gaming"
      "media"
      "node"
      "productivity"
      "security"
      "slack"
      "utils"
    ];
  } {
    home.packages = [ pkgs.gh ];

    programs.git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;

        userName = "Max Bolotin";
        userEmail = "maks.bolotin@gmail.com";

        aliases = {
        adog = "log --all --decorate --oneline --graph";
        };
    };

    # Change user and set a password !
    users.users.max = {
      isNormalUser = true;
      description = "Max Bolotin";
      shell = pkgs.zsh;
      extraGroups = [ "networkmanager" "wheel" "docker" ];
    };
  }];
  system = "x86_64-linux";
}
