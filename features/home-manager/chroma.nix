{pkgs, copper, ...}: {
  copper.chroma = {
    enable = true;
    initialTheme = "Catppuccin-Mocha";
  };
  copper.chroma.themes = copper.chromaThemes;

  copper.chroma.gtk = {
    enable = true;
    #flatpak.enable = true;
    gtk4.libadwaitaSupport = "patch-binary";
  };

  copper.chroma.qt.enable = true;
}
