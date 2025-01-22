{
  pkgs,
  lib,
  ...
}:
# terminal config
let
  font = "Iosevka";
in {
  programs.kitty = {
    enable = true;
    # package = maxdots.packages.kitty-nightly;
    font.name = lib.mkForce font;
    settings = {
      background_blur = 10;
      dynamic_background_opacity = "yes";
      hide_window_decorations =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "titlebar-only"
        else "yes";
      window_margin_width = 5;
      window_padding_width = 5;
      background_opacity = "1";
      # macos_thicken_font = 1;
      font_size = 22;
      # modify_font = "cell_height 110%";
      confirm_os_window_close = 0;
      placement_strategy = "top-left";
      # text_composition_strategy = "legacy";
      cursor_trail = 3;
    };
    keybindings = {
      "cmd+h" = "";
      "cmd+k" = "";
    };
  };
}
