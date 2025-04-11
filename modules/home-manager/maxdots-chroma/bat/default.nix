{
  config,
  lib,
  pkgs,
  options,
  ...
}:
with lib; let
  cfg = config.maxdots.chroma;

  # Taken verbatim from upstream bat module:
  toConfigFile = attrs: let
    inherit (builtins) isBool attrNames;
    nonBoolFlags = filterAttrs (_: v: !(isBool v)) attrs;
    enabledBoolFlags = filterAttrs (_: v: isBool v && v) attrs;

    keyValuePairs =
      generators.toKeyValue {
        mkKeyValue = k: v: "--${k}=${lib.escapeShellArg v}";
        listsAsDuplicateKeys = true;
      }
      nonBoolFlags;
    switches = concatMapStrings (k: ''
      --${k}
    '') (attrNames enabledBoolFlags);
  in
    keyValuePairs + switches;

  inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;
in {
  options = {
    maxdots.chroma.bat = {
      enable = mkEnableOption "Bat theming" // {default = config.programs.bat.enable;};
    };
  };

  config = mkMerge [
    {
      maxdots.chroma.programs.bat = {
        themeOptions = {
          colorOverrides = mkOption {
            type = types.attrsOf colorType;
            default = {};
            description = ''
              Color overrides to apply to the palette-generated theme.
            '';
          };
          theme = mkOption {
            default = null;
            type = lib.types.nullOr options.programs.bat.themes.type.nestedTypes.elemType;
            example = literalExpression ''
              {
                src = pkgs.fetchFromGitHub {
                  owner = "dracula";
                  repo = "sublime"; # Bat uses sublime syntax for its themes
                  rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
                  sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
                };
                file = "Dracula.tmTheme";
              }
            '';
            description = "The bat theme to use.";
          };
        };

        themeConfig = args: {
          file."config".text = toConfigFile (config.programs.bat.config // {theme = "_chroma_${args.config.themeName}";});
        };
      };
    }
    (mkIf (cfg.enable && cfg.bat.enable) {
      assertions = [
        {
          assertion = config.programs.bat.enable;
          message = "The bat module is required for Chroma's bat integration.";
        }
        {
          assertion = !(config.home.sessionVariables ? BAT_THEME || config.programs.bat.config ? theme);
          message = "When using Chroma's bat integration, do not configure a theme via other means.";
        }
      ];

      programs.bat = {
        themes = let
          generateDynamic = name: theme: let
            dyn = theme.palette.generateDynamic {
              template = ./bat.tmTheme.dyn;
              paletteOverrides = theme.bat.colorOverrides;
            };
            src = pkgs.runCommand "tmTheme_${name}" {} ''
              mkdir -p $out
              cp ${dyn} $out/${name}.tmTheme
            '';
          in {
            inherit src;
            file = "${name}.tmTheme";
          };
        in
          mapAttrs' (name: value: {
            name = "_chroma_${name}";
            value =
              if value.bat.theme == null
              then (generateDynamic name value)
              else value.bat.theme;
          })
          cfg.themes;
      };

      xdg.configFile."bat/config".source = mkOverride 1 (config.lib.file.mkOutOfStoreSymlink "${config.maxdots.chroma.themeDirectory}/active/bat/config");
    })
  ];
}
