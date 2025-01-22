{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.copper.chroma;
in {
  options = {
    copper.chroma.kitty-procpsfix.enable = mkOption {
      type = types.bool;
      default = config.programs.kitty.enable;
      example = false;
      description = ''
        Whether to enable Kitty theming as part of Chroma.
      '';
    };
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.enable && cfg.kitty-procpsfix.enable) || config.programs.kitty.enable;
        message = "Chroma Kitty theming requires Kitty to be enabled.";
      }
    ];
    # TODO: set the font to the monospace font?

    copper.chroma.programs.kitty = let
      pkill =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "/usr/bin/pkill"
        else "${pkgs.procps}/bin/pkill";
    in {
      reloadCommand = lib.mkForce "${pkill} -USR1 -u $USER kitty || true";
    };

    programs.kitty.settings.include = mkIf (cfg.enable && cfg.kitty-procpsfix.enable) "${config.copper.chroma.themeDirectory}/active/kitty/theme.conf";
  };
}
