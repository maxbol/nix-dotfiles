{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;

  cfg = config.maxdots.chroma;
in {
  options = {
    maxdots.chroma.firefox = {
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

      package = lib.mkOption {
        type = lib.types.path;
        example = "pkgs.firefox";
        default = config.programs.firefox.package;
        description = ''
          Path to the installed firefox package
        '';
      };

      vimiumFontFamily = lib.mkOption {
        type = lib.types.str;
        example = "Iosevka";
        default = config.textfox.config.font.family or "Arial";
        description = ''
          Font family to apply to vimium omnibar and hints. Defaults to the same font as is used in textfox config.
        '';
      };
    };
  };

  config = {
    maxdots.chroma.programs.firefox = {
      themeOptions = {
        enableColors = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''Wether to apply theme colors to firefox chrome and omnibar'';
        };
        enableSiteColors = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''Wether to apply theme colors to a select number of sites'';
        };
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

          chromeColorsCss = opts.palette.generateDynamic {
            template = ./colors.css.dyn;
            paletteOverrides = config.colorOverrides;
          };

          siteColorsCss = opts.palette.generateDynamic {
            template = ./sitecolors.css.dyn;
            paletteOverrides = config.colorOverrides;
          };

          colorsCss = pkgs.writeText "colors.css" (lib.strings.concatStringsSep "\n" [
            (
              if config.enableColors == true
              then (builtins.readFile chromeColorsCss)
              else ""
            )
            (
              if config.enableSiteColors == true
              then (builtins.readFile siteColorsCss)
              else ""
            )
          ]);
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

              :root {
                --vimium-font-family: "${cfg.firefox.vimiumFontFamily}" !important;
              }
            '';
          };
        };
      })
  ];
}
