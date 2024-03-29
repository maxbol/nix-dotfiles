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
      window_padding_width = 5;
      background_opacity = "0.95";
      font_size = 12;
      confirm_os_window_close = 0;
      placement_strategy = "top-left";
      text_composition_strategy = "legacy";
    };
  };
}
