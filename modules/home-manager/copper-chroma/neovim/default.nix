{
  config,
  lib,
  pkgs,
  origin,
  ...
}:
with lib; let
  cfg = config.copper.chroma;
  nvim-colorctl = origin.inputs.nvim-colorctl.packages.${pkgs.system}.default;

  inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;
in {
  options = {
    copper.chroma.neovim.enable = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = ''
        Whether to enable neovim themeing as part of Chroma.
      '';
    };
  };

  config = {
    copper.chroma.programs.neovim = {
      themeOptions = {
        colorscheme = mkOption {
          type = types.string;
          example = "nord";
          description = ''
            The neovim theme to use.
          '';
        };
        background = mkOption {
          type = types.string;
          example = "dark";
          default = "dark";
          description = ''
            The background to use.
          '';
        };
      };

      themeConfig = {config, ...}: {
        file."colorscheme" = {
          required = true;
          source = mkDefault (pkgs.writeText "colorscheme" "${config.colorscheme}");
        };
        file."background" = {
          required = true;
          source = mkDefault (pkgs.writeText "background" "${config.background}");
        };
      };

      reloadCommand = "${lib.getExe nvim-colorctl} --emit-lua ~/.config/nvim/lua/neomax/color/init.lua -s $(cat ~/.config/chroma/active/neovim/colorscheme) -b $(cat ~/.config/chroma/active/neovim/background)";
    };
  };
}
