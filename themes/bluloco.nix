{
  pkgs,
  accent ? "blue",
  accent2 ? "red",
  accent3 ? "green",
  hyprlandOverrides ? p: {},
  waybarOverrides ? p: {},
  rofiOverrides ? p: {},
  tmuxOverrides ? p: {},
  neovimOverrides ? p: {},
  sketchybarOverrides ? p: {},
  yaziOverrides ? p: {},
  luminance,
  ...
}: let
  bluloco_pkg = pkgs.fetchFromGitHub {
    owner = "uloco";
    repo = "bluloco.nvim";
    rev = "main";
    hash = "sha256-z2kRBlggu0g9qblr2yT18SV+mGNUxekDXs49scZDKf0=";
  };

  capitalize = str: "${pkgs.lib.toUpper (builtins.substring 0 1 str)}${builtins.substring 1 (builtins.stringLength str) str}";

  palette_ = {
    fg = "b9c0cb";
    bg = "282c34";
    bg_float = "21242D";
    cursor = "ffcc00";
    cursor_text = "282c34";
    black = "41444d";
    red = "fc2f52";
    green = "25a45c";
    yellow = "ff936a";
    blue = "3476ff";
    magenta = "7a82da";
    cyan = "4483aa";
    white = "cdd4e0";
    bright_black = "8f9aae";
    bright_red = "ff637f";
    bright_green = "3fc56a";
    bright_yellow = "f9c858";
    bright_blue = "10b0fe";
    bright_magenta = "ff78f8";
    bright_cyan = "5fb9bc";
    bright_white = "ffffff";
  };

  palette_dark = rec {
    colors = {
      red = palette_.bright_red;
      green = palette_.bright_green;
      yellow = palette_.bright_yellow;
      blue = palette_.bright_blue;
    };

    accents = {
      inherit (colors) red green yellow blue;
      magenta = palette_.bright_magenta;
      cyan = palette_.bright_cyan;
      orange = palette_.yellow;
    };

    semantic = {
      text = palette_.fg;
      text1 = palette_.white;
      text2 = palette_.bright_white;
      overlay = palette_.black;
      surface = palette_.bg_float;
      background = palette_.bg;
      accent1 = accents.${accent};
      accent2 = accents.${accent2};
      accent3 = accents.${accent3};
    };
  };

  palette_light = rec {
    colors = {
      red = palette_.red;
      green = palette_.green;
      yellow = palette_.yellow;
      blue = palette_.blue;
    };

    accents = {
      inherit (colors) red green yellow blue;
      magenta = palette_.magenta;
      cyan = palette_.cyan;
      orange = palette_.yellow;
    };

    semantic = {
      text = palette_.bg;
      text1 = palette_.bright_black;
      text2 = palette_.black;
      overlay = palette_.white;
      surface = palette_.bright_white;
      background = palette_.fg;
      accent1 = accents.${accent};
      accent2 = accents.${accent2};
      accent3 = accents.${accent3};
    };
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
    purple = "#${palette.accents.magenta}"
    aqua = "#${palette.accents.cyan}"
    orange = "#${palette.accents.yellow}"
  '';

  starshipPalettes = pkgs.writeText "starship-palettes.toml" ''
    ${mkStarshipPalette "bluloco-dark" palette_dark}
    ${mkStarshipPalette "bluloco-light" palette_light}
  '';

  Luminance = capitalize luminance;
in rec {
  palette =
    if luminance == "dark"
    then palette_dark
    else palette_light;

  hyprland.colorOverrides = hyprlandOverrides palette;

  waybar.colorOverrides = waybarOverrides palette;

  rofi.colorOverrides = rofiOverrides palette;

  tmux.colorOverrides = tmuxOverrides palette;

  sketchybar.colorOverrides = sketchybarOverrides palette;

  yazi.syntectTheme = "${bluloco_pkg}/extra/bat/.config/bat/themes/bluloco-${luminance}/bluloco-${luminance}.tmTheme";
  yazi.colorOverrides = yaziOverrides palette;

  neovim = neovimOverrides palette;

  dynawall = {
    shader = "voronoi2nobuf";
    colorOverrides = {
      accents = [
        ("#" + palette.accents.blue)
        ("#" + palette.accents.magenta)
        ("#" + palette.accents.red)
        ("#" + palette.accents.orange)
      ];
    };
  };

  kitty = {
    file."theme.conf".source = "${bluloco_pkg}/terminal-themes/kitty/Bluloco${Luminance}.conf";
  };

  starship.palette = {
    file = starshipPalettes;
    name = "bluloco-${luminance}";
  };

  bat.theme = {
    src = bluloco_pkg;
    file = "extra/bat/.config/bat/themes/bluloco-${luminance}/bluloco-${luminance}.tmTheme";
  };

  macoswallpaper = {
    wallpaper = "$HOME/wallpapers/bluloco-default.jpg";
  };
}
