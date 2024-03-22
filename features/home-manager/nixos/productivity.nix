{pkgs, ...}: {
  home.packages = with pkgs; [
    # productivity
    obsidian
    notion-app-enhanced
    calibre
    gvfs
    krita
  ];
}
