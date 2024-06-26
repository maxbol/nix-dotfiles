{
  maxdots,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true;

  home.packages = [
    maxdots.packages.tableplus
    maxdots.packages.dbvisualizer
    pkgs.azuredatastudio
    pkgs.beekeeper-studio
    pkgs.dbeaver-bin
    pkgs.jetbrains.datagrip
  ];
}
