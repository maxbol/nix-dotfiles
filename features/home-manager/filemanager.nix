{pkgs, ...}: {
  home.packages = with pkgs; [
    libsForQt5.dolphin
    libsForQt5.kdegraphics-thumbnailers
    kdePackages.kdesdk-thumbnailers
    libsForQt5.qt5.qtimageformats
  ];
}
