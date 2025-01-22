{pkgs, ...}: {
  home.packages = with pkgs; [
    obsidian
  ];

  programs.obsidian-config = {
    enable = true;
    vaults = [
      "Notes/maxnotes"
    ];
    config = {
      appearance = {
        enable = true;
        interfaceFontFamily = "Iosevka";
        textFontFamily = "Iosevka";
        monospaceFontFamily = "Iosevka";
      };
    };
  };
}
