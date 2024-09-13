{pkgs, ...}: {
  home.packages = with pkgs; [
    # productivity
    obsidian
    imagemagick
  ];
}
