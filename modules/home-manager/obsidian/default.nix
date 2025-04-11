{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.programs.obsidian-config;
  # basename = path: lib.splitString "/" path |> lib.last;
  basename = path: lib.last (lib.splitString "/" path);
in
  with lib; {
    options = {
      programs.obsidian-config = {
        enable = mkEnableOption "obsidian-config";

        vaults = mkOption {
          type = types.listOf types.str;
          default = [];
          example = ["vaults/work" "vaults/personal"];
          description = ''
            List of vaults to copy Obsidian settings into. Note that the module does not take any responsibility for actually creating the vaults or their directories. It only syncs settings for these vaults.
          '';
        };

        config = mkOption {
          type = types.submodule {
            options = {
              appearance = mkOption {
                type = types.submodule {
                  options = {
                    enable = mkOption {
                      type = types.bool;
                      default = false;
                    };
                    cssTheme = mkOption {
                      type = types.path;
                      example = "./Soothe";
                    };
                    baseFontSize = mkOption {
                      type = types.int;
                      example = 16;
                      default = 16;
                    };
                    interfaceFontFamily = mkOption {
                      type = types.str;
                      example = "Fira Code";
                    };
                    textFontFamily = mkOption {
                      type = types.str;
                      example = "Fira Code";
                    };
                    monospaceFontFamily = mkOption {
                      type = types.str;
                      example = "Fira Code";
                    };
                  };
                };
                default = {};
              };
            };
          };
          default = {};
        };
      };
    };

    imports = [
      (mkIf cfg.enable (let
        mkDebug = vaultDir: {
          file."${vaultDir}/.obsidian/test" = {
            source = pkgs.writeText "test" "test";
          };
        };
      in {
        home = foldl' (acc: vaultDir: mkDebug vaultDir // acc) {} cfg.vaults;
      }))
      # Appearance settings
      (
        mkIf (cfg.enable && cfg.config.appearance.enable) (let
          themesDir = pkgs.runCommand "obsidian-themes" {} ''
            mkdir -p $out
            cp -R ${cfg.config.appearance.cssTheme} $out/
          '';

          # themesDir = pkgs.stdenv.mkDerivation {
          #   name = "obsidian-themes";
          #   buildInputs = [];
          #   installPhase = ''
          #     mkdir -p $out
          #     cp -R ${cfg.config.appearance.cssTheme} $out/
          #   '';
          # };

          appearanceJson = pkgs.writeText "appearance.json" ''
            {
              "cssTheme": "${basename cfg.config.appearance.cssTheme}",
              "interfaceFontFamily": "${cfg.config.appearance.interfaceFontFamily}",
              "textFontFamily": "${cfg.config.appearance.textFontFamily}",
              "monospaceFontFamily": "${cfg.config.appearance.monospaceFontFamily}",
              "baseFontSize": ${toString cfg.config.appearance.baseFontSize}
            }
          '';

          mkVaultConfig = vaultDir: {
            file."${vaultDir}/.obsidian/appearance.json" = {
              source = appearanceJson;
            };

            file."${vaultDir}/.obsidian/themes" = {
              source = themesDir;
            };
          };
        in {
          home = foldl' (acc: vaultDir: mkVaultConfig vaultDir // acc) {} cfg.vaults;
        })
      )
    ];
  }
