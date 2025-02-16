{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.maxdots.chroma;
in {
  options = {
    maxdots.chroma.kitty.enable = mkOption {
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
        assertion = !(cfg.enable && cfg.kitty.enable) || config.programs.kitty.enable;
        message = "Chroma Kitty theming requires Kitty to be enabled.";
      }
    ];
    # TODO: set the font to the monospace font?

    maxdots.chroma.programs.kitty = let
      pkill =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "/usr/bin/pkill"
        else "${pkgs.procps}/bin/pkill";
    in {
      reloadCommand = lib.mkForce "${pkill} -USR1 -u $USER kitty || true";
    };

    programs.kitty.settings.include = mkIf (cfg.enable && cfg.kitty.enable) "${config.maxdots.chroma.themeDirectory}/active/kitty/theme.conf";
  };
}
