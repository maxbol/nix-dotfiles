{
  pkgs,
  lib,
  origin,
  ...
}: let
  nixpkgs-unstable = origin.inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  programs.kitty = {
    enable = true;
    package = nixpkgs-unstable.kitty;
    # package = maxdots.packages.kitty-nightly;
    # ->
    # =>
    # font = let
    #   # font = "Iosevka Comfy";
    #   font = "Iosevka";
    #   fontSize = 18;
    #   # font = "Iosevka Comfy";
    #   # fontSize = 18;
    #   # fontPackage = pkgs.iosevka-comfy.comfy;
    #   # fontSize = 18;
    #   # font = "Fira Code";
    #   # fontSize = 16;
    #   fontPackage = pkgs.symlinkJoin {
    #     name = "kitty-terminal-fonts";
    #     paths = [
    #       pkgs.iosevka
    #       pkgs.iosevka-comfy.comfy
    #       pkgs.iosevka-comfy.comfy-duo
    #       pkgs.iosevka-comfy.comfy-fixed
    #       pkgs.iosevka-comfy.comfy-wide-motion-fixed
    #       pkgs.iosevka-comfy.comfy-wide
    #       pkgs.fira-code
    #       nixpkgs-unstable.aporetic
    #     ];
    #   };
    # in {
    #   name = lib.mkForce font;
    #   package = fontPackage;
    #   size = fontSize;
    # };
    settings = {
      background_blur = 10;
      dynamic_background_opacity = "yes";
      hide_window_decorations =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "titlebar-only"
        else "yes";
      window_margin_width = 5;
      window_padding_width = 5;
      # background_opacity = "0.6";
      background_opacity = "1";
      # macos_thicken_font = 1;
      modify_font = "cell_height 120%";
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
