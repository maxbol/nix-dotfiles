{
  pkgs,
  accent ? "yellow",
  accent2 ? "wisteria",
  accent3 ? "green",
  hyprlandOverrides ? p: {},
  waybarOverrides ? p: {},
  rofiOverrides ? p: {},
  tmuxOverrides ? p: {},
  sketchybarOverrides ? p: {},
  neovimOverrides ? p: {},
  ...
}: let
  palette_ = {
    base = "003078"; # "#003078"
    surface = "0070d2"; # "#0070d2"
    overlay = "0090e2"; # "#0090e2"
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

    darkyellow = "f4bb00";
    dustypink = "e1aacc";
    slimygreen = "d2ee88";
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
      inherit (palette_) darkred darkbrown wisteria niagara lightred darkestniagara darkyellow dustypink slimygreen;
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

  sketchybar.colorOverrides = sketchybarOverrides palette;

  neovim =
    {
      colorscheme = "borland";
      hlGroupsBg = {
        Normal = "none";
        NormalFloat = "#" + palette.semantic.overlay;
      };
      hlGroupsFg = {
        lualine_a_normal = "#" + palette.semantic.text;
        Type = "#" + palette.accents.dustypink;
        "@function.call" = "#" + palette.accents.darkyellow;
        "@keyword" = "#" + palette.accents.slimygreen;
      };
    }
    // neovimOverrides palette;

  dynawall.colorOverrides = {
    accents = [
      ("#" + palette.accents.niagara)
    ];
  };

  kitty = {
    font = {
      name = "PxPlus IBM VGA 9x16";
      size = 18;
      package = pkgs.ultimate-oldschool-pc-font-pack;
    };
    autoGenerate = {
      enable = true;
      colorOverrides = {
        color0 = palette.semantic.background;
        color1 = palette.accents.red;
        color2 = palette.accents.green;
        color3 = palette.accents.darkbrown;
        color4 = palette.accents.niagara;
        color5 = palette.accents.wisteria;
        color6 = palette.accents.niagara;
        color7 = palette.semantic.text;
        color8 = palette.semantic.overlay;
        color9 = palette.accents.darkred;
        color10 = palette.accents.yellow;
        color11 = palette.accents.darkbrown;
        color12 = palette.accents.wisteria;
        color13 = palette.accents.niagara;
        color14 = palette.accents.wisteria;
        color15 = palette.semantic.text2;
      };
    };
  };

  starship.palette = {
    file = starshipPalettes;
    name = "tsoding-mode";
  };

  macoswallpaper = {
    # wallpaper = "$HOME/wallpapers/tsodingmode-default.png";
    wallpaper = "$HOME/wallpapers/tsodingmode-default2.jpg";
  };
}
