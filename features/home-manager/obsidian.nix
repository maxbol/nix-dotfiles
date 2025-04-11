{
  pkgs,
  origin,
  ...
}: let
  obsidian-remote-cli = origin.inputs.obsidian-remote.packages.${pkgs.system}.default;
  monoFont = "Iosevka";
in {
  home.packages = with pkgs; [
    obsidian
    obsidian-remote-cli
    fira-code
  ];

  programs.obsidian-config = {
    enable = true;
    vaults = [
      "Notes/maxnotes"
    ];
    config = {
      appearance = {
        enable = true;
        interfaceFontFamily = monoFont;
        textFontFamily = monoFont;
        monospaceFontFamily = monoFont;
        baseFontSize = 18;
      };
    };
  };
}
