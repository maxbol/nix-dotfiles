{
  pkgs,
  self,
  variant ? "pine",
  accent ? "rose",
  accent2 ? "pine",
  accent3 ? "foam",
  hyprlandOverrides ? p: {},
  waybarOverrides ? p: {},
  rofiOverrides ? p: {},
  tmuxOverrides ? p: {},
  sketchybarOverrides ? p: {},
  neovimOverrides ? p: {},
  macoswallpaperOverrides ? {},
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
    eclipse = {
      base = "111111"; # "#111111"
      surface = "282828"; # "#282828"
      overlay = "453d41"; # "#453d41"
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
      highlightLow = palette_.${variant}.highlightLow;
      highlightMed = palette_.${variant}.highlightMed;
      highlightHigh = palette_.${variant}.highlightHigh;
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
    else
      (
        if variant == "eclipse"
        then "rose-pine-moon"
        else "rose-pine-${variant}"
      );

  kittyThemeFileName = "${normalizedThemeName}.conf";

  tmTheme = pkgs.fetchFromGitHub {
    owner = "rose-pine";
    repo = "tm-theme";
    rev = "c4235f9a65fd180ac0f5e4396e3a86e21a0884ec";
    hash = "sha256-jji8WOKDkzAq8K+uSZAziMULI8Kh7e96cBRimGvIYKY=";
  };
in rec {
  inherit palette;

  hyprland.colorOverrides = hyprlandOverrides palette;

  waybar.colorOverrides = waybarOverrides palette;

  rofi.colorOverrides = rofiOverrides palette;

  tmux.colorOverrides = tmuxOverrides palette;

  sketchybar.colorOverrides = sketchybarOverrides palette;

  neovim = neovimOverrides palette;

  yazi.colorOverrides = {
    filetype_fallback_dir_fg = palette.accents.${accent3};
  };
  yazi.syntectTheme = "${tmTheme}/dist/themes/${normalizedThemeName}.tmTheme";

  dynawall.shader = "monterrey2";
  dynawall.colorOverrides = {
    accents = [
      ("#" + palette.accents.love)
      ("#" + palette.accents.foam)
      ("#" + palette.accents.iris)
      ("#" + palette.accents.gold)
    ];
  };

  kitty = {
    file."theme.conf".source =
      if variant == "eclipse"
      then ./resources/rosepine/eclipse/kitty.conf
      else "${pkgs.kitty-themes}/share/kitty-themes/themes/${kittyThemeFileName}";
  };

  starship.palette = {
    file = starshipPalettes;
    name = "rose-pine";
  };

  bat.theme = {
    src = tmTheme;
    file = "dist/themes/${normalizedThemeName}.tmTheme";
  };

  macoswallpaper =
    {
      wallpaper = "$HOME/wallpapers/rosepine-default${
        if variant == "moon"
        then "-3"
        else if variant == "eclipse"
        then "-eclipse"
        else ""
      }.png";
    }
    // macoswallpaperOverrides;
}
