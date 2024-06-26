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
  copper.chroma.themes.Catppuccin-Latte.swim.wallpaperDirectory = "${config.home.homeDirectory}/wallpapers/latte";
  copper.chroma.themes.Catppuccin-Mocha.swim.wallpaperDirectory = "${config.home.homeDirectory}/wallpapers/mocha";
  copper.chroma.themes.Gruvbox-Dark.swim.wallpaperDirectory = "${config.home.homeDirectory}/wallpapers/gruvbox-dark";
  copper.chroma.themes.Gruvbox-Light.swim.wallpaperDirectory = "${config.home.homeDirectory}/wallpapers/gruvbox-light";
}
