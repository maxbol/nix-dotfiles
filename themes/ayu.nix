{
  pkgs,
  self,
  variant ? "dark",
  accent ? "yellow",
  accent2 ? "blue",
  accent3 ? "orange",
  hyprlandOverrides ? p: {},
  waybarOverrides ? p: {},
  rofiOverrides ? p: {},
  tmuxOverrides ? p: {},
  sketchybarOverrides ? p: {},
  neovimOverrides ? p: {},
  ...
}: let
  variants = [
    "dark"
    "mirage"
    "light"
  ];

  ayuTmTheme = pkgs.fetchFromGitHub {
    owner = "dempfi";
    repo = "ayu";
    rev = "3.2.2";
    sha256 = "sha256-BDkZ7RsUx8t20n7i6htCQM/vPOR89guWfAOaCXi1oC0=";
  };

  ayuFishTheme = pkgs.fetchFromGitHub {
    owner = "edouard-lopez";
    repo = "ayu-theme.fish";
    rev = "v2.0.0";
    sha256 = "sha256-rx9izD2pc3hLObOehuiMwFB4Ta5G1lWVv9Jdb+JHIz0=";
  };

  ayuYaziFlavor = pkgs.fetchFromGitHub {
    owner = "kmlupreti";
    repo = "ayu-dark.yazi";
    rev = "441a38d56123e8670dd4962ab126f6d9f1942f40";
    sha256 = "sha256-AaTCYzZe90Wri/jnku8pO2hXTFhqBPlAGBo5U9gwfSs=";
  };

  ayuPaletteToJson = pkgs.buildNpmPackage {
    pname = "ayu-palette-to-json";
    version = "1.0.0";
    src = ./resources/ayu/ayuPalette2Json;
    npmDepsHash = "sha256-RHOOeJ9jpBF5SwKFcGUPBJK8E/u9XmpSKR4MJzz+Tv8=";
    postInstall = ''
      cp $out/lib/node_modules/ayupalette2json/dist/palette.json $out/palette.json
    '';
  };

  ayuPaletteJson = pkgs.lib.pipe "${ayuPaletteToJson}/palette.json" [
    builtins.readFile
    builtins.fromJSON
  ];

  toChromaPalette = jsonPalette: rec {
    colors = {
      red = jsonPalette.syntax.markup;
      green = jsonPalette.syntax.string;
      yellow = jsonPalette.common.accent;
      blue = jsonPalette.syntax.entity;
    };

    accents = {
      inherit (colors) red green yellow blue;
      lightblue = jsonPalette.syntax.tag;
      teal = jsonPalette.syntax.regexp;
      orange = jsonPalette.syntax.keyword;
      grey = jsonPalette.syntax.comment;
      mauve = jsonPalette.syntax.constant;
      peach = jsonPalette.syntax.operator;
    };

    semantic = {
      text = jsonPalette.editor.fg;
      text1 = jsonPalette.ui.fg;
      text2 = jsonPalette.ui.selection.active;
      overlay = jsonPalette.editor.bg;
      surface = jsonPalette.ui.panel.bg;
      background = jsonPalette.ui.bg;
      accent1 = accents.${accent};
      accent2 = accents.${accent2};
      accent3 = accents.${accent3};
    };
  };

  allPalettes = builtins.foldl' (all: v: all // {${v} = toChromaPalette (ayuPaletteJson.${v});}) {} variants;

  telaMap = {
    "red" = "red";
    "green" = "green";
    "yellow" = "yellow";
    "blue" = "blue";
    "purple" = "mauve";
    "aqua" = "teal";
    "orange" = "orange";
  };

  mkStarshipPalette = v: let
    p = allPalettes.${v};
  in ''
    [palettes.ayu_${v}]
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

  starshipPalettes = pkgs.writeText "starship-palettes.toml" (pkgs.lib.concatStringsSep "\n\n" (map mkStarshipPalette variants));
in rec {
  palette = allPalettes.${variant};

  hyprland.colorOverrides = hyprlandOverrides palette;

  waybar.colorOverrides = waybarOverrides palette;

  rofi.colorOverrides = rofiOverrides palette;

  tmux.colorOverrides = tmuxOverrides palette;

  sketchybar.colorOverrides = sketchybarOverrides palette;

  yazi.flavor = ayuYaziFlavor;
  yazi.generateThemeTomlFromPalette = false;

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
    confName =
      if variant == "dark"
      then "ayu.conf"
      else "ayu_${variant}.conf";
    themeFile = "${pkgs.kitty-themes}/share/kitty-themes/themes/${confName}";
    themeConf = builtins.readFile themeFile;

    themeSource = pkgs.writeText "theme.conf" ''
      ${themeConf}
      # background_opacity 1

      ${
        if variant == "latte"
        then ''
          background_opacity 1
          macos_thicken_font 1
        ''
        else ""
      }
    '';
  in {
    file."theme.conf".source = themeSource;
  };

  starship.palette = {
    file = starshipPalettes;
    name = "ayu_${variant}";
  };

  bat.theme = {
    src = ayuTmTheme;
    file = "ayu-${variant}.tmTheme";
  };

  # TODO: replace with actual-pine theme
  fish.theme = {
    file = "${ayuFishTheme}/conf.d/ayu-${variant}.fish";
    name = "ayu_${variant}";
  };

  macoswallpaper = {
    wallpaper = "$HOME/wallpapers/ayu-${
      if variant == "mirage"
      then "mirage-default.png"
      else "dark-default.jpg"
    }";
  };
}
