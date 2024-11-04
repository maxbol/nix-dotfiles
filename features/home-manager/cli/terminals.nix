{
  pkgs,
  lib,
  maxdots,
  ...
}:
# terminal config
let
  # font = "CaskaydiaCove Nerd Font Mono";
  # font = "JetBrainsMono Nerd Font";
  # font = "Hack Nerd Font";
  # font = "Fira Code Nerd Font Mono";
  # font = "MesloLGL Nerd Font Mono";
  font = "Iosevka";
  # font = "BigBlueTerm437 Nerd Font";
in {
  programs.kitty = {
    enable = true;
    package = maxdots.packages.kitty-nightly;
    font.name = lib.mkForce font;
    settings = {
      background_blur = 0;
      hide_window_decorations = "yes";
      window_padding_width = 5;
      background_opacity = "0.9";
      # macos_thicken_font = 1;
      font_size = 20;
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
