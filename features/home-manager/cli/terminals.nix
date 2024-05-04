{
  pkgs,
  lib,
  ...
}:
# terminal config
let
  font = "JetBrainsMono Nerd Font";
in {
  programs.kitty = {
    enable = true;
    font.name = lib.mkForce font;
    settings = {
      background_blur = 0;
      hide_window_decorations = "yes";
      window_padding_width = 5;
      background_opacity = "1";
      font_size = 13;
      confirm_os_window_close = 0;
      placement_strategy = "top-left";
      text_composition_strategy = "legacy";
    };
    keybindings = {
      "cmd+h" = "";
      "cmd+k" = "";
    };
  };
}
