{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;

  cfg = config.copper.chroma;
in {
  options = {
    copper.chroma.firefox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.programs.firefox.enable;
        example = false;
        description = ''
          Whether to enable Firefox settings as part of Chroma.
        '';
      };

      profile = lib.mkOption {
        type = lib.types.str;
        example = "default";
        default = config.textfox.profile;
        description = ''
          The name of the Firefox profile to apply the themeing to.
        '';
      };
    };
  };

  config = {
    copper.chroma.programs.firefox = {
      themeOptions = {
        colorOverrides = lib.mkOption {
          type = lib.types.attrsOf colorType;
          default = {};
          description = ''
            Color overrides to apply to the palette-generated theme.
          '';
        };
      };

      themeConfig = {
        config,
        opts,
        ...
      }: {
        file."setcolors.sh" = let
          profileDir =
            if pkgs.stdenv.hostPlatform.isDarwin
            then "Library/Application\ Support/Firefox/Profiles"
            else ".mozilla/firefox";

          colorsCss = opts.palette.generateDynamic {
            template = ./colors.css.dyn;
            paletteOverrides = config.colorOverrides;
          };
        in {
          required = true;
          source = lib.mkDefault (pkgs.writeScript "setcolors.sh" ''
            profile_dir="$HOME/${profileDir}/${cfg.firefox.profile}"
            chrome_dir="$profile_dir/chrome"
            mkdir -p "$chrome_dir"

            cp ${colorsCss} "$chrome_dir/colors.css"
            chown -R $USER "$chrome_dir/colors.css"
            chmod 744 "$chrome_dir/colors.css"
          '');
        };
      };

      reloadCommand = "~/.config/chroma/active/firefox/setcolors.sh";
    };
  };

  imports = [
    (lib.mkIf
      (cfg.enable && cfg.firefox.enable)
      {
        textfox = {
          config = {
            customCss = ''
              @import url("colors.css");
            '';
          };
        };
      })
  ];
}
