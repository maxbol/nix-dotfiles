{
  pkgs,
  ...
}: {
  # Fonts for system and TWM
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      hack-font
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      noto-fonts-extra

      # nerdfonts
      (nerdfonts.override { fonts = [ "Hack" "JetBrainsMono" "DroidSansMono" ]; })
    ];

    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    # Do I need this?
    fontconfig.defaultFonts = {
      serif = [ ];
      sansSerif = [ ];
      monospace = [ ];
      emoji = [ ];
    };
  };
}