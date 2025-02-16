{maxdots, ...}: {
  maxdots.chroma = {
    enable = true;
    initialTheme = "Catppuccin-Mocha";
  };
  maxdots.chroma.themes = maxdots.chromaThemes;

  maxdots.chroma.gtk = {
    enable = true;
    #flatpak.enable = true;
    gtk4.libadwaitaSupport = "patch-binary";
  };

  maxdots.chroma.qt.enable = true;
}
