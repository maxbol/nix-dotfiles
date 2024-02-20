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
      "_1password"
      "dunst"
      "hyprland"
      "rofi"
      "swaylock"
      "swim"
      "waybar-hyprdots"
      "waybar"
      "wlogout"
    ];
    copper.file.symlink.base = "/home/max/dotfiles";

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
  }];
  system = "x86_64-linux";
}
