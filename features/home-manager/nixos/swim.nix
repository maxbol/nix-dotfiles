{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.swww = {
    enable = true;
    systemd = {
      enable = true;
      installTarget = "hyprland-session.target";
    };
  };

  copper.swim = {
    enable = true;
    chromaIntegration = {
      enable = true;
    };
    wallpaperDirectory = "${config.home.homeDirectory}/wallpapers";
    extraSwwwArgs = lib.mkIf config.maxdots.feature.hyprland.enable [''--transition-pos'' ''"$( hyprctl cursorpos )"''];
  };
  # TODO: this doesn't belong here
  maxdots.chroma.themes.Catppuccin-Latte.swim.wallpaperDirectory = "${config.home.homeDirectory}/wallpapers/latte";
  maxdots.chroma.themes.Catppuccin-Mocha.swim.wallpaperDirectory = "${config.home.homeDirectory}/wallpapers/mocha";
  maxdots.chroma.themes.Gruvbox-Dark.swim.wallpaperDirectory = "${config.home.homeDirectory}/wallpapers/gruvbox-dark";
  maxdots.chroma.themes.Gruvbox-Light.swim.wallpaperDirectory = "${config.home.homeDirectory}/wallpapers/gruvbox-light";
}
