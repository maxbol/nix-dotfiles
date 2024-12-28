{maxdots, ...}: {
  copper.chroma = {
    enable = true;
    initialTheme = "Catppuccin-Mocha";
  };
  copper.chroma.themes = maxdots.chromaThemes;

  copper.chroma.kitty.enable = false;
  copper.chroma.kitty-procpsfix.enable = true;
}
