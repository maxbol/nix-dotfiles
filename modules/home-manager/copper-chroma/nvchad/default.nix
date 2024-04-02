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
    copper.chroma.nvchad.enable = mkOption {
      type = types.bool;
      default = config.programs.nvchad.enable;
      example = false;
      description = ''
        Whether to enable NvChad UI theming as part of Chroma.
      '';
    };
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.enable && cfg.nvchad.enable) || config.programs.nvchad.enable;
        message = "Chroma NvChad UI theming requires NvChad to be enabled.";
      }
    ];

    copper.chroma.programs.nvchad = {
      themeOptions = {
        theme = mkOption {
          type = types.str;
          example = "nord";
          description = ''
            The NvChad theme to use.
          '';
        };
      };

      themeConfig = {
        config,
        opts,
        ...
      }: let
        themeFile = pkgs.writeText "ui.lua" ''
          return function(highlights)
            local M = {
              theme = "${config.theme}",
              hl_override = highlights.override,
              hl_add = highlights.add,
            }

            return M
          end
        '';
      in {
        file."ui.lua".source = themeFile;
      };
    };

    programs.nvchad.uiLua = mkIf (cfg.enable && cfg.nvchad.enable) "${config.copper.chroma.themeDirectory}/active/nvchad/ui.lua";
  };
}
