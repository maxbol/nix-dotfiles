{pkgs, ...}: {
  home.packages = with pkgs; [
    killlall
    nix-info
  ];
}
