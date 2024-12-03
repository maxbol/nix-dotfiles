{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.copper.chroma;
  inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;
in {
  options = {
    copper.chroma.yazi.enable = mkOption {
      type = types.bool;
      default = config.programs.yazi.enable;
      example = false;
      description = ''
        Enable Chroma integration for Yazi
      '';
    };
  };

  config = let
    enabled = cfg.yazi.enable && config.programs.yazi.enable;
    toFlavorName = themeName: "_chroma_" + (toLower (replaceStrings [" "] ["_"] themeName));
    mkFlavor = name: value: let
      flavorDerivation = value.yazi.flavor;
      flavorName = toFlavorName name;
    in
      pkgs.stdenv.mkDerivation {
        name = "chroma-yazi-flavor-${flavorName}";
        src = flavorDerivation;
        installPhase = ''
          mkdir -p "''$out/${flavorName}.yazi"
          cp -r $src/* "''$out/${flavorName}.yazi"
        '';
      };
    mkFlavorsDerivation = themes: let
      themesWithFlavor = filterAttrs (name: value: value.yazi.flavor != null) themes;
      paths = mapAttrsToList mkFlavor themesWithFlavor;
    in
      pkgs.symlinkJoin {
        name = "chroma-yazi-flavors";
        inherit paths;
      };
  in
    mkMerge [
      {
        copper.chroma.programs.yazi = {
          themeOptions = {
            colorOverrides = mkOption {
              type = types.attrsOf colorType;
              default = {};
              description = ''
                Color overrides to apply to the palette-generated theme.
              '';
            };
            generateThemeTomlFromPalette = mkOption {
              type = types.bool;
              default = true;
              example = false;
              description = ''
                Whether or not to generate full theme.toml settings from the chroma palette. If false, a flavor must be specified.
              '';
            };
            syntectTheme = mkOption {
              type = types.nullOr types.path;
              default = null;
              example = "./theme.tmTheme";
              description = ''
                The path to a syntect theme to use for the Yazi theme. Only use if a flavor is not available.
              '';
            };
            flavor = mkOption {
              type = types.anything;
              default = null;
              example = "./gruvbox";
              description = ''
                The flavor to use for the Yazi theme.
              '';
            };
          };

          themeConfig = {
            config,
            opts,
            ...
          }:
            mkMerge [
              {
                file."theme.toml" = with config; let
                  flavorName = toFlavorName opts.name;
                  flavorInclude =
                    if flavor == null
                    then ""
                    else ''
                      [flavor]
                      use="${flavorName}"

                    '';
                  injectSyntectTheme = toml:
                    if syntectTheme != null
                    then replaceStrings ["[manager]"] ["[manager]\nsyntect_theme=\"${syntectTheme}\""] toml
                    else toml;
                  themeToml = ''
                    ${flavorInclude}
                    ${
                      if generateThemeTomlFromPalette
                      then
                        injectSyntectTheme (builtins.readFile (opts.palette.generateDynamic {
                          template = ./theme.toml.dyn;
                          paletteOverrides = colorOverrides;
                        }))
                      else ""
                    }
                  '';
                in {
                  required = true;
                  source = mkDefault (pkgs.writeText "theme.toml" themeToml);
                };
              }
            ];
        };
      }
      (
        mkIf enabled
        {
          assertions = [
            {
              assertion = config.programs.yazi.enable;
              message = "Yazi Chroma integration only works when the yazi home-manager module is enabled.";
            }
          ];

          home.file."${config.xdg.configHome}/yazi/flavors" = {
            source = mkFlavorsDerivation cfg.themes;
          };

          home.file."${config.xdg.configHome}/yazi/theme.toml" = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/chroma/active/yazi/theme.toml";
          };
        }
      )
    ];
}
