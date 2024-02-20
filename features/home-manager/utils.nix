{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # archives
    zip
    unzip

    # utils
    ripgrep
    ranger
    xdragon
    evince
    vlc
    neofetch
    gotop

    # misc
    xdg-utils
    graphviz
    nodejs
    emote

    qbittorrent
  ];
}
