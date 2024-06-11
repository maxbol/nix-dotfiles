{pkgs, ...}: {
  home.packages = with pkgs; [
    killall
    nix-info
    usbutils
    moreutils
  ];
}
