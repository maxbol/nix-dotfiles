{
  pkgs,
  self,
  luminance ? "dark",
  accent ? "orange",
  accent2 ? "blue",
  accent3 ? "aqua",
  hyprlandOverrides ? p: {},
  waybarOverrides ? p: {},
  rofiOverrides ? p: {},
  tmuxOverrides ? p: {},
  ...
}: let
  capitalize = str: "${pkgs.lib.toUpper (builtins.substring 0 1 str)}${builtins.substring 1 (builtins.stringLength str) str}";

  palette_ = {
    dark0 = "282828"; # "#282828"
    dark1 = "3c3836"; # "#3c3836"
    dark2 = "504945"; # "#504945"
    light0 = "fbf1c7"; # "#fbf1c7"
    light1 = "ebdbb2"; # "#ebdbb2"
    light2 = "d5c4a1"; # "#d5c4a1"
    brightred = "fb4934"; # "#fb4934"
    brightgreen = "b8bb26"; # "#b8bb26"
    brightyellow = "fabd2f"; # "#fabd2f"
    brightblue = "83a598"; # "#83a598"
    brightpurple = "d3869b"; # "#d3869b"
    brightaqua = "8ec07c"; # "#8ec07c"
    brightorange = "fe8019"; # "#fe8019"
    neutralred = "cc241d"; # "#cc241d"
    neutralgreen = "98971a"; # "#98971a"
    neutralyellow = "d79921"; # "#d79921"
    neutralblue = "458588"; # "#458588"
    neutralpurple = "b16286"; # "#b16286"
    neutralaqua = "689d6a"; # "#689d6a"
    neutralorange = "d65d0e"; # "#d65d0e"
    fadedred = "9d0006"; # "#9d0006"
    fadedgreen = "79740e"; # "#79740e"
    fadedyellow = "b57614"; # "#b57614"
    fadedblue = "076678"; # "#076678"
    fadedpurple = "8f3f71"; # "#8f3f71"
    fadedaqua = "427b58"; # "#427b58"
    fadedorange = "af3a03"; # "#af3a03"
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

  globalaccents = {
    inherit (palette_) brightred brightgreen brightyellow brightblue brightpurple brightaqua brightorange neutralred neutralgreen neutralyellow neutralblue neutralpurple neutralaqua neutralorange fadedred fadedgreen fadedyellow fadedblue fadedpurple fadedaqua fadedorange;
  };

  palette_dark = rec {
    colors = {
      red = palette_.brightred;
      green = palette_.brightgreen;
      yellow = palette_.brightyellow;
      blue = palette_.brightblue;
    };

    accents =
      {
        inherit (colors) red green yellow blue;
        purple = palette_.brightpurple;
        aqua = palette_.brightaqua;
        orange = palette_.brightorange;
      }
      // globalaccents;

    semantic = {
      text = palette_.light0;
      text1 = palette_.light1;
      text2 = palette_.light2;
      overlay = palette_.dark2;
      surface = palette_.dark1;
      background = palette_.dark0;
      accent1 = accents.${accent};
      accent2 = accents.${accent2};
      accent3 = accents.${accent3};
    };
  };

  palette_light = rec {
    colors = {
      red = palette_.fadedred;
      green = palette_.fadedgreen;
      yellow = palette_.fadedyellow;
      blue = palette_.fadedblue;
    };

    accents =
      {
        inherit (colors) red green yellow blue;
        purple = palette_.fadedpurple;
        aqua = palette_.fadedaqua;
        orange = palette_.fadedorange;
      }
      // globalaccents;

    semantic = {
      text = palette_.dark0;
      text1 = palette_.dark1;
      text2 = palette_.dark2;
      overlay = palette_.light2;
      surface = palette_.light1;
      background = palette_.light0;
      accent1 = accents.${accent};
      accent2 = accents.${accent2};
      accent3 = accents.${accent3};
    };
  };

  Luminance = capitalize luminance;

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
    ${mkStarshipPalette "gruvbox-dark" palette_dark}
    ${mkStarshipPalette "gruvbox-light" palette_light}
  '';
in rec {
  palette =
    if luminance == "dark"
    then palette_dark
    else palette_light;

  hyprland.colorOverrides = hyprlandOverrides palette;

  waybar.colorOverrides = waybarOverrides palette;

  rofi.colorOverrides = rofiOverrides palette;

  tmux.colorOverrides = tmuxOverrides palette;

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
    theme.package =
      pkgs
      .gruvbox-gtk-theme
      .overrideAttrs (prev: {propagatedUserEnvPkgs = prev.propagatedUserEnvPkgs ++ [pkgs.gnome.gnome-themes-extra];});
    theme.name = "Gruvbox-${Luminance}-BL";
    documentFont = desktop.font;
    colorScheme = "prefer-${luminance}";
  };

  qt = {
    kvantum = {
      package = self.hyprdots-kvantum;
      name = "Gruvbox-Retro";
    };

    qtct = {
      package = self.hyprdots-qt5ct;
      name = "Gruvbox-Retro";
    };
  };

  kitty = {
    file."theme.conf".source = "${pkgs.kitty-themes}/share/kitty-themes/themes/gruvbox-${luminance}.conf";
  };

  # TODO: replace with actual gruvbox theme
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
    name = "gruvbox-${luminance}";
  };

  bat.theme = {
    src = pkgs.fetchFromGitHub {
      owner = "subnut";
      repo = "gruvbox-tmTheme";
      rev = "64c47250e54298b91e2cf8d401320009aba9f991";
      hash = "sha256-aw6uFn9xGhyv4TJwNgLUQbP72hoB7d+79X9jVcEQAM4=";
    };
    file = "gruvbox-${luminance}.tmTheme";
  };

  nvchad.theme = "gruvchad";
}
