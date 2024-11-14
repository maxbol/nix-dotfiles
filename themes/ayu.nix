{
  pkgs,
  variant ? "dark",
  accent ? "blue",
  accent2 ? "green",
  accent3 ? "red",
  hyprlandOverrides ? p: {},
  waybarOverrides ? p: {},
  rofiOverrides ? p: {},
  tmuxOverrides ? p: {},
  neovimOverrides ? p: {},
  luminance ? "dark",
  ...
}: let
  ayuColors = pkgs.buildNpmPackage {
    pname = "ayu";
    version = "8.0.1";
    src = pkgs.fetchFromGitHub {
      owner = "ayu-theme";
      repo = "ayu-colors";
      rev = "60fdf5d39c5ef36c081b081c1fb90b5e7cc24f4d";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  };

  ayuPaletteJson = pkgs.mkDerivation {
    src = pkgs.writeText {
      name = "ayuPaletteToJson.js";
      executable = true;
      destination = "/ayuPaletteToJson.js";
      text = ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i node -p nodejs
        const colors = require("${ayuColors}");
        const theme = colors.${variant};

        const paletteJson = {};

        for (const groupKey in theme) {
          if (paletteJson[groupKey] === undefined) {
            paletteJson[groupKey] = {};
          }

          for (const colorKey in theme[groupKey]) {
            paletteJson[groupKey][colorKey] = theme[groupKey][colorKey].hex("rgb");
          }
        }

        console.log(JSON.stringify(paletteJson));
      '';
    };
  };

  ayuPaletteToJson = pkgs.writeText {
    name = "ayuPaletteToJson.js";
    executable = true;
    destination = "/ayuPaletteToJson.js";
    text = ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i node -p nodejs
      const colors = require("${ayuColors}");
      const theme = colors.${variant};

      const paletteJson = {};

      for (const groupKey in theme) {
        if (paletteJson[groupKey] === undefined) {
          paletteJson[groupKey] = {};
        }

        for (const colorKey in theme[groupKey]) {
          paletteJson[groupKey][colorKey] = theme[groupKey][colorKey].hex("rgb");
        }
      }

      console.log(JSON.stringify(paletteJson));
    '';
  }
  

  capitalize = str: "${pkgs.lib.toUpper (builtins.substring 0 1 str)}${builtins.substring 1 (builtins.stringLength str) str}";

  palette_ = builtins.toJSON (ayuPaletteToJson)

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

  kitty = let
    themeFile = "${bluloco_pkg}/terminal-themes/kitty/Bluloco${Luminance}.conf";
    themeConf = builtins.readFile themeFile;

    themeSource = pkgs.writeText "theme.conf" ''
      ${themeConf}

      background_opacity 0.95
      # background_opacity 1.0
      # background_blur 10
      # macos_thicken_font 1
    '';
  in {
    file."theme.conf".source = themeSource;
  };

  starship.palette = {
    file = starshipPalettes;
    name = "bluloco-${luminance}";
  };

  bat.theme = {
    src = bluloco_pkg;
    file = "extra/bat/.config/bat/themes/bluloco-${luminance}/bluloco-${luminance}.tmTheme";
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

  macoswallpaper = {
    wallpaper = "$HOME/wallpapers/bluloco-default.jpg";
  };
}
