{
  pkgs,
  origin,
  ...
}: let
  obsidian-remote-cli = origin.inputs.obsidian-remote.packages.${pkgs.system}.default;
in {
  home.packages = with pkgs; [
    obsidian
    obsidian-remote-cli
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
