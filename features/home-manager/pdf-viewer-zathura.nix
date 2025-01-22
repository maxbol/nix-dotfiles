{pkgs, ...}: {
  home.packages = [
    pkgs.zathura
  ];

  copper.chroma.zathura.enable = true;
}
