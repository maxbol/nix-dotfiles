{
  pkgs,
  lib,
  copper,
  maxdots,
  ...
}: {
  copper.chroma = {
    enable = true;
    initialTheme = "Catppuccin-Mocha";
  };
  copper.chroma.themes = maxdots.chromaThemes;

  copper.chroma.gtk = {
    enable = true;
    #flatpak.enable = true;
    gtk4.libadwaitaSupport = "patch-binary";
  };

  copper.chroma.qt.enable = true;
}
