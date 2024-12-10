{pkgs, ...}: let
in {
  home.packages = with pkgs; [
    spotify-player
  ];
}
