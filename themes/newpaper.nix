{
  pkgs,
  lib,
  luminance ? "light",
  accent1 ? "darkblue",
  accent2 ? "darkgreen",
  accent3 ? "darkorange",
  neovimOverrides ? p: {},
  ...
}: let
  luminanceOptions = [
    "light"
    "dark"
  ];

  palsrc = {
    light = {
      text = "2B2B2B";
      text1 = "333333";
      text2 = "444444";
      bg = "F1F3F2";
      bg1 = "e1e3e2";
      bg2 = "d1d3d2";
      darkred = "af0000";
      lightred = "e14133";
      darkgreen = "008700";
      lightgreen = "50a14f";
      darkorange = "af5f00";
      lightorange = "d75f00";
      darkblue = "27408b";
      lightblue = "0072c1";
      darkpurple = "8700af";
      lightpurple = "e563ba";
      darkcyan = "005f87";
      lightcyan = "0087af";
    };
    dark = {
      text = "c6c8cd";
      text1 = "bcbcbc";
      text2 = "cdcdcd";
      bg = "303030";
      bg1 = "404040";
      bg2 = "505050";
      darkred = "cc5555";
      lightred = "dc5761";
      darkgreen = "75b680";
      lightgreen = "5faf5f";
      darkorange = "c57a30";
      lightorange = "f5824b";
      darkblue = "8195e7";
      lightblue = "7db1d5";
      darkpurple = "a274d1";
      lightpurple = "e878d8";
      darkcyan = "72aeb3";
      lightcyan = "5fafd7";
    };
  };

  mkPalette = palette_: rec {
    semantic = {
      text = palette_.text;
      text1 = palette_.text2;
      text2 = palette_.text2;
      overlay = palette_.bg2;
      surface = palette_.bg1;
      background = palette_.bg;
      accent1 = palette_.${accent1};
      accent2 = palette_.${accent2};
      accent3 = palette_.${accent3};
    };
    accents = {
      inherit (palette_) darkgreen darkorange darkred darkcyan darkpurple darkblue lightred lightorange lightgreen lightpurple lightblue lightcyan;
      inherit (colors) red green blue yellow;
      mauve = palette_.darkpurple;
      teal = palette_.darkcyan;
    };
    colors = {
      red = palette_.darkred;
      green = palette_.darkgreen;
      blue = palette_.darkblue;
      yellow = palette_.lightorange;
    };
  };

  allPalettes = {
    light = mkPalette palsrc.light;
    dark = mkPalette palsrc.dark;
  };

  mkStarshipPalette = v: let
    p = allPalettes.${v};
  in ''
    [palettes.newpaper_${v}]
    text = "#${p.semantic.text}"
    subtext0 = "#${p.semantic.text1}"
    subtext1 = "#${p.semantic.text2}"
    surface0 = "#${p.semantic.background}"
    surface1 = "#${p.semantic.surface}"
    surface2 = "#${p.semantic.surface}"
    overlay0 = "#${p.semantic.overlay}"
    overlay1 = "#${p.semantic.overlay}"
    overlay2 = "#${p.semantic.overlay}"
    red = "#${p.colors.red}"
    green = "#${p.colors.green}"
    yellow = "#${p.colors.yellow}"
    blue = "#${p.colors.blue}"
    purple = "#${p.accents.mauve}"
    aqua = "#${p.accents.teal}"
    orange = "#${p.accents.yellow}"
  '';
in rec {
  palette = allPalettes.${luminance};

  neovim =
    {
      colorscheme = "newpaper";
    }
    // (neovimOverrides palette);

  kitty = {
    autoGenerate = {
      enable = true;
      colorOverrides = {
        color0 = palette.semantic.background;
        color1 = palette.accents.darkred;
        color2 = palette.accents.darkgreen;
        color3 = palette.accents.darkorange;
        color4 = palette.accents.darkblue;
        color5 = palette.accents.darkpurple;
        color6 = palette.accents.darkcyan;
        color7 = palette.semantic.text;
        color8 = palette.semantic.overlay;
        color9 = palette.accents.lightred;
        color10 = palette.accents.lightgreen;
        color11 = palette.accents.lightorange;
        color12 = palette.accents.lightblue;
        color13 = palette.accents.lightpurple;
        color14 = palette.accents.lightcyan;
        color15 = palette.semantic.text2;
      };
    };
  };

  starship.palette = let
    starshipPalettes = pkgs.writeText "starship-palettes.toml" (pkgs.lib.concatStringsSep "\n\n" (map mkStarshipPalette luminanceOptions));
  in {
    file = starshipPalettes;
    name = "newpaper_${luminance}";
  };

  bat = {
    theme = null;
    colorOverrides = {};
  };

  macoswallpaper = {
    wallpaper = "$HOME/wallpapers/newpaper-${
      if luminance == "light"
      then "light"
      else "dark"
    }.jpg";
  };

  firefox = let
    enable = luminance == "dark";
  in {
    enableColors = enable;
    enableSiteColors = enable;
  };
}
