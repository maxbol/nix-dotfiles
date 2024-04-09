{pkgs, ...}: {
  home.packages = with pkgs; [
    # productivity
    obsidian
    notion-app-enhanced
    font-manager
    calibre
    gvfs
    krita
    gimp
    pinta
  ];
}
