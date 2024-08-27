{
  pkgs,
  self,
  variant ? "pine",
  accent ? "love",
  accent2 ? "gold",
  accent3 ? "rose",
  hyprlandOverrides ? p: {},
  waybarOverrides ? p: {},
  rofiOverrides ? p: {},
  tmuxOverrides ? p: {},
  neovimColorscheme ? "rose-pine",
  neovimBackground ? "dark",
  ...
}: let
  luminance =
    if variant == "dawn"
    then "light"
    else "dark";

  palette_ = {
    pine = {
      base = "191724"; # "#191724"
      surface = "1f1d2e"; # "#1f1d2e"
      overlay = "26233a"; # "#26233a"
      muted = "6e6a86"; # "#6e6a86"
      subtle = "908caa"; # "#908caa"
      text = "e0def4"; # "#e0def4"
      love = "eb6f92"; # "#eb6f92"
      gold = "f6c177"; # "#f6c177"
      rose = "ebbcba"; # "#ebbcba"
      pine = "31748f"; # "#31748f"
      foam = "9ccfd8"; # "#9ccfd8"
      iris = "c4a7e7"; # "#c4a7e7"
      highlightLow = "21202e"; # "#21202e"
      highlightMed = "403d52"; # "#403d52"
      highlightHigh = "524f67"; # "#524f67"
    };
    moon = {
      base = "232136"; # "#232136"
      surface = "2a273f"; # "#2a273f"
      overlay = "393552"; # "#393552"
      muted = "6e6a86"; # "#6e6a86"
      subtle = "908caa"; # "#908caa"
      text = "e0def4"; # "#e0def4"
      love = "eb6f92"; # "#eb6f92"
      gold = "f6c177"; # "#f6c177"
      rose = "ea9a97"; # "#ea9a97"
      pine = "3e8fb0"; # "#3e8fb0"
      foam = "9ccfd8"; # "#9ccfd8"
      iris = "c4a7e7"; # "#c4a7e7"
      highlightLow = "2a283e"; # "#2a283e"
      highlightMed = "44415a"; # "#44415a"
      highlightHigh = "56526e"; # "#56526e"
    };
    dawn = {
      base = "faf4ed"; # "#faf4ed"
      surface = "fffaf3"; # "#fffaf3"
      overlay = "f2e9e1"; # "#f2e9e1"
      muted = "9893a5"; # "#9893a5"
      subtle = "797593"; # "#797593"
      text = "575279"; # "#575279"
      love = "b4637a"; # "#b4637a"
      gold = "ea9d34"; # "#ea9d34"
      rose = "d7827e"; # "#d7827e"
      pine = "286983"; # "#286983"
      foam = "56949f"; # "#56949f"
      iris = "907aa9"; # "#907aa9"
      highlightLow = "f4ede8"; # "#f4ede8"
      highlightMed = "dfdad9"; # "#dfdad9"
      highlightHigh = "cecacd"; # "#cecacd"
    };
  };

  telaMap = {
    "red" = "red";
    "green" = "green";
    "yellow" = "yellow";
    "blue" = "blue";
    "purple" = "purple";
    "aqua" = "blue";
    "orange" = "orange";
  };

  mkPalette = variant: rec {
    colors = {
      red = palette_.${variant}.love;
      green = palette_.${variant}.pine;
      yellow = palette_.${variant}.gold;
      blue = palette_.${variant}.foam;
    };

    accents = {
      inherit (colors) red green yellow blue;
      inherit (palette_.${variant}) love gold pine foam rose iris;
      orange = palette_.${variant}.rose;
      purple = palette_.${variant}.iris;
      aqua = palette_.${variant}.foam;
    };

    semantic = {
      text = palette_.${variant}.text;
      text1 = palette_.${variant}.subtle;
      text2 = palette_.${variant}.muted;
      overlay = palette_.${variant}.overlay;
      surface = palette_.${variant}.surface;
      background = palette_.${variant}.base;
      accent1 = accents.${accent};
      accent2 = accents.${accent2};
      accent3 = accents.${accent3};
    };
  };

  palette = mkPalette variant;

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
    ${mkStarshipPalette "rose-pine" palette}
  '';

  normalizedThemeName =
    if variant == "pine"
    then "rose-pine"
    else "rose-pine-${variant}";

  kittyThemeFileName = "${normalizedThemeName}.conf";
in rec {
  inherit palette;

  hyprland.colorOverrides = hyprlandOverrides palette;

  waybar.colorOverrides = waybarOverrides palette;

  rofi.colorOverrides = rofiOverrides palette;

  tmux.colorOverrides = tmuxOverrides palette;

  neovim.colorscheme = neovimColorscheme;
  neovim.background = neovimBackground;

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
  gtk = {
    theme.package = pkgs.rose-pine-gtk;
    theme.name = normalizedThemeName;
    documentFont = desktop.font;
    colorScheme = "prefer-${luminance}";
  };

  qt = {
    kvantum = {
      package = self.hyprdots-kvantum;
      name = "Rose-Pine";
    };

    qtct = {
      package = self.hyprdots-qt5ct;
      name = "Rose-Pine";
    };
  };

  kitty = {
    file."theme.conf".source = "${pkgs.kitty-themes}/share/kitty-themes/themes/${kittyThemeFileName}";
  };

  # TODO: replace with actual rose-pine theme
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
    name = "rose-pine";
  };

  bat.theme = {
    src = pkgs.fetchFromGitHub {
      owner = "rose-pine";
      repo = "tm-theme";
      rev = "c4235f9a65fd180ac0f5e4396e3a86e21a0884ec";
      hash = "sha256-jji8WOKDkzAq8K+uSZAziMULI8Kh7e96cBRimGvIYKY=";
    };
    file = "dist/themes/${normalizedThemeName}.tmTheme";
  };
}
