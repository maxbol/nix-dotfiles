{
  maxdots,
  pkgs,
  ...
}: {
  programs.zathura = {
    enable = true;
    package = maxdots.packages.zathura-darwin;
  };
}
