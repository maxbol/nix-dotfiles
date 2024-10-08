{
  pkgs,
  accent ? "yellow",
  accent2 ? "niagara",
  accent3 ? "lightred",
  hyprlandOverrides ? p: {},
  waybarOverrides ? p: {},
  rofiOverrides ? p: {},
  tmuxOverrides ? p: {},
  neovimOverrides ? p: {},
  ...
}: let
  palette_ = {
    base = "181818"; # "#181818"
    surface = "282828"; # "#282828"
    overlay = "453d41"; # "#453d41"
    muted = "e4e4e4"; # "#e4e4e4"
    subtle = "f4f4ff"; # "#f4f4ff"
    text = "f5f5f5"; # "#f5f5f5"
    yellow = "ffdd33"; # "#ffdd33"
    green = "73d936"; # "#73d936"
    darkred = "c73c3f"; # "#c73c3f"
    darkbrown = "cc8c3c"; # "#cc8c3c"
    red = "f43841"; # "#f43841"
    wisteria = "9e95c7"; # "#9e95c7"
    niagara = "96a6c8"; # "#96a6c8"
    lightred = "ff4f58"; # "#ff4f58"
    darkestniagara = "303540"; # "#303540"
    highlightLow = "21202e"; # "#21202e"
    highlightMed = "9e95c7"; # "#9e95c7"
    highlightHigh = "96a6c8"; # "#96a6c8"
  };

  telaMap = {
    "red" = "red";
    "green" = "green";
    "yellow" = "yellow";
    "blue" = "niagara";
    "purple" = "wisteria";
    "aqua" = "niagara";
    "orange" = "darkbrown";
  };

  palette = rec {
    colors = {
      red = palette_.red;
      green = palette_.green;
      yellow = palette_.yellow;
      blue = palette_.niagara;
    };

    accents = {
      inherit (colors) red green yellow blue;
      inherit (palette_) darkred darkbrown wisteria niagara lightred darkestniagara;
      orange = palette_.darkbrown;
      purple = palette_.wisteria;
      aqua = palette_.niagara;
    };

    semantic = {
      text = palette_.text;
      text1 = palette_.subtle;
      text2 = palette_.muted;
      overlay = palette_.overlay;
      surface = palette_.surface;
      background = palette_.base;
      accent1 = accents.${accent};
      accent2 = accents.${accent2};
      accent3 = accents.${accent3};
    };
  };

  mkStarshipPalette = name: palette: ''
    [palettes.${name}]
    text = "#${palette.semantic.text}"
    subtext0 = "#${palette.semantic.text1}"
    subtext1 = "#${palette.semantic.text2}"
    surface0 = "#${palette.semantic.background}"
    surface1 = "#${palette.semantic.surface}"
    surface2 = "#${palette.semantic.surface}"
    overlay0 = "#${palette.semantic.overlay}"
    overlay1 = "#${palette.semantic.overlay}"
    overlay2 = "#${palette.semantic.overlay}"
    red = "#${palette.colors.red}"
    green = "#${palette.colors.green}"
    yellow = "#${palette.colors.yellow}"
    blue = "#${palette.colors.blue}"
    purple = "#${palette.accents.purple}"
    aqua = "#${palette.accents.aqua}"
    orange = "#${palette.accents.orange}"
  '';

  starshipPalettes = pkgs.writeText "starship-palettes.toml" ''
    ${mkStarshipPalette "tsoding-mode" palette}
  '';
in rec {
  inherit palette;

  hyprland.colorOverrides = hyprlandOverrides palette;

  waybar.colorOverrides = waybarOverrides palette;

  rofi.colorOverrides = rofiOverrides palette;

  tmux.colorOverrides = tmuxOverrides palette;

  neovim = neovimOverrides palette;

  desktop = {
    # Note: this propagatedInputs override should be upstreamed to nixpkgs
    iconTheme.package = pkgs.tela-icon-theme.overrideAttrs (final: prev: {propagatedBuildInputs = prev.propagatedBuildInputs ++ [pkgs.gnome.adwaita-icon-theme pkgs.libsForQt5.breeze-icons];});
    iconTheme.name = "Tela-${telaMap.${accent}}";
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Original-Ice";
    cursorTheme.size = 20;
    font.name = "Cantarell";
    font.size = 10;
    font.package = pkgs.cantarell-fonts;
    monospaceFont.name = "CaskaydiaCove Nerd Font Mono";
    monospaceFont.size = 9;
    monospaceFont.package = pkgs.nerdfonts;
  };
  # gtk = {
  #   theme.package = pkgs.rose-pine-gtk;
  #   theme.name = normalizedThemeName;
  #   documentFont = desktop.font;
  #   colorScheme = "prefer-${luminance}";
  # };

  # qt = {
  #   kvantum = {
  #     package = self.hyprdots-kvantum;
  #     name = "Rose-Pine";
  #   };
  #
  #   qtct = {
  #     package = self.hyprdots-qt5ct;
  #     name = "Rose-Pine";
  #   };
  # };

  kitty = let
    themeFile = ./resources/tsoding-mode/kitty.conf;
    themeConf = builtins.readFile themeFile;

    themeSource = pkgs.writeText "theme.conf" ''
      ${themeConf}

      background_opacity 1
      # font_family Iosevka Nerd Font Mono
    '';
  in {
    file."theme.conf".source = themeSource;
  };

  # TODO: replace with actual-pine theme
  fish.theme = {
    file = "${pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "fish";
      rev = "91e6d6721362be05a5c62e235ed8517d90c567c9";
      hash = "sha256-l9V7YMfJWhKDL65dNbxaddhaM6GJ0CFZ6z+4R6MJwBA=";
    }}/themes/Catppuccin Mocha.theme";
    name = "Catppuccin Mocha";
  };

  starship.palette = {
    file = starshipPalettes;
    name = "tsoding-mode";
  };

  bat.theme = {
    src = pkgs.fetchFromGitHub {
      owner = "rose-pine";
      repo = "tm-theme";
      rev = "c4235f9a65fd180ac0f5e4396e3a86e21a0884ec";
      hash = "sha256-jji8WOKDkzAq8K+uSZAziMULI8Kh7e96cBRimGvIYKY=";
    };
    file = "dist/themes/rose-pine.tmTheme";
  };
}
