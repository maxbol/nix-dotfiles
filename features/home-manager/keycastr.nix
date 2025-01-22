{pkgs, ...}: {
  home.packages = with pkgs; [
    keycastr
  ];
}
