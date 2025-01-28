{
  pkgs,
  config,
  lib,
  origin,
  ...
}: let
  cfg = config.copper.chroma;
  inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;
in
  with lib; {
    options = {
      copper.chroma.obsidian.enable = mkOption {
        type = types.bool;
        default = config.programs.obsidian-config.enable;
        example = false;
        description = ''
          Whether to enable Obsidian settings as part of Chroma.
        '';
      };
    };

    config = {
      copper.chroma.programs.obsidian = {
        themeOptions = {
          colorOverrides = mkOption {
            type = types.attrsOf colorType;
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
          file."obsidianChroma" = {
            source = let
              dynamicPalette =
                opts.palette.generateDynamic
                {
                  template = ./theme/theme.css.dyn;
                  paletteOverrides = config.colorOverrides;
                };
            in
              pkgs.runCommand "obsidianChroma" {} ''
                mkdir -p $out
                cp -r ${./theme}/manifest.json $out/manifest.json
                cp ${dynamicPalette} $out/theme.css
              '';
          };
        };

        reloadCommand = let
          obsidian-remote-cli = origin.inputs.obsidian-remote.packages.${pkgs.system}.default;
        in
          lib.mkForce "${obsidian-remote-cli}/bin/obsidian-remote run-command app:reload";
      };
    };

    imports = [
      (
        mkIf (cfg.enable && cfg.obsidian.enable) {
          programs.obsidian-config = {
            config = {
              appearance = {
                enable = true;
                cssTheme = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/chroma/active/obsidian/obsidianChroma";
              };
            };
          };
        }
      )
    ];
  }
