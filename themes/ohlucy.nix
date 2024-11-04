{
  pkgs,
  accent ? "red",
  accent2 ? "green",
  accent3 ? "blue",
  hyprlandOverrides ? p: {},
  waybarOverrides ? p: {},
  rofiOverrides ? p: {},
  tmuxOverrides ? p: {},
  neovimOverrides ? p: {},
  ...
}: let
  pkg = pkgs.fetchFromGitHub {
    owner = "yazeed1s";
    repo = "oh-lucy.nvim";
    rev = "main";
    hash = "sha256-Iu1W/bsHChJ2ADw1MLqKmJ5CLP66K5+xDUsIFkbrlKQ=";
  };

  # The original palette from yazeed1s/oh-lucy.nvim
  palette_ = {
    fg = "d7d7d7"; # #D7D7D7
    bg = "1b1d26"; # #1B1D26
    none = "1b1d26"; # #1B1D26
    dark = "14161d"; # #14161D
    comment = "5e6173"; # #5E6173
    popup_back = "515761"; # #515761
    cursor_fg = "d7d7d7"; # #D7D7D7
    context = "515761"; # #515761
    cursor_bg = "aeafad"; # #AEAFAD
    accent = "bbbbbb"; # #BBBBBB
    diff_add = "8cd881"; # #8CD881
    diff_change = "6caec0"; # #6CAEC0
    cl_bg = "707891"; # #707891
    diff_text = "568bb4"; # #568BB4
    line_fg = "555b6c"; # #555B6C
    line_bg = "1b1d26"; # #1B1D26
    gutter_bg = "1b1d26"; # #1B1D26
    non_text = "606978"; # #606978
    selection_bg = "5e697e"; # #5E697E
    selection_fg = "495163"; # #495163
    vsplit_fg = "cccccc"; # #cccccc
    vsplit_bg = "21252d"; # #21252D
    visual_select_bg = "272932"; # #272932
    red_key_w = "fb7da7"; # #FB7DA7
    red_err = "d95555"; # #D95555
    green_func = "74c7a4"; # #74C7A4
    green = "76c5a4"; # #76C5A4
    blue_type = "8dbbd3"; # #8DBBD3
    black1 = "272932"; # #272932
    black = "14161d"; # #14161D
    white1 = "d7d7d7"; # #D7D7D7
    white = "e9e9e9"; # #E9E9E9
    gray_punc = "7c7e8c"; # #7C7E8C
    gray2 = "6e7380"; # #6E7380
    gray1 = "343842"; # #343842
    gray = "21252d"; # #21252D
    orange = "e0828d"; # #E0828D
    boolean = "af98e6"; # #AF98E6
    orange_wr = "e39a65"; # #E39A65
    pink = "bda9d4"; # #BDA9D4
    yellow = "e3cf65"; # #E3CF65
  };

  palette = rec {
    colors = {
      red = palette_.red_key_w;
      green = palette_.green;
      yellow = palette_.yellow;
      blue = palette_.blue_type;
    };

    accents = {
      inherit (colors) red green yellow blue;
      magenta = palette_.pink;
      cyan = palette_.diff_change;
      orange = palette_.orange_wr;
    };

    semantic = {
      text = palette_.fg;
      text1 = palette_.white;
      text2 = palette_.white1;
      overlay = palette_.black;
      surface = palette_.black1;
      background = palette_.bg;
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
    ${mkStarshipPalette "oh-lucy" palette}
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

  kitty = let
    themeFile = "${pkg}/terminal/kitty/ohlucy.conf";

    themeConf = builtins.readFile themeFile;

    themeSource = pkgs.writeText "theme.conf" ''
      ${themeConf}

      background_opacity 0.9
      # background_blur 10
      # macos_thicken_font 1
    '';
  in {
    file."theme.conf".source = themeSource;
  };

  starship.palette = {
    file = starshipPalettes;
    name = "oh-lucy";
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
    wallpaper = "$HOME/wallpapers/bluloco-default.png";
  };
}
