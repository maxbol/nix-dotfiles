{
  config,
  lib,
  pkgs,
  origin,
  ...
}:
with lib; let
  nvim-colorctl = origin.inputs.nvim-colorctl.packages.${pkgs.system}.default;
  homeDirectory = config.home.homeDirectory;
  # inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;
in {
  options = {
    maxdots.chroma.neovim.enable = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = ''
        Whether to enable neovim themeing as part of Chroma.
      '';
    };
  };

  config = {
    maxdots.chroma.programs.neovim = {
      themeOptions = {
        colorscheme = mkOption {
          type = types.str;
          example = "nord";
          description = ''
            The neovim theme to use.
          '';
        };
        background = mkOption {
          type = types.str;
          example = "dark";
          default = "dark";
          description = ''
            The background to use.
          '';
        };
        hlGroupsBg = mkOption {
          type = types.attrs;
          example = {
            Normal = "#282c34";
            CursorLine = "#3b4048";
          };
          default = {};
          description = ''
            A mapping of highlight groups to their background color.
          '';
        };
        hlGroupsFg = mkOption {
          type = types.attrs;
          example = {
            Normal = "#282c34";
            CursorLine = "#3b4048";
          };
          default = {};
          description = ''
            A mapping of highlight groups to their foreground color.
          '';
        };
      };

      themeConfig = {config, ...}: let
        padArg = arg:
          if arg == ""
          then ""
          else " ${arg}";

        fgGroups = padArg (lib.concatStringsSep " " (lib.mapAttrsToList (name: value: "--hi-fg ${name},${value}") config.hlGroupsFg));
        bgGroups = padArg (lib.concatStringsSep " " (lib.mapAttrsToList (name: value: "--hi-bg ${name},${value}") config.hlGroupsBg));
      in {
        file."colorctl" = let
          cmd = "${lib.getExe nvim-colorctl} --emit-lua ${homeDirectory}/.config/nvim/lua/neomax/color/init.lua -s ${config.colorscheme} -b ${config.background}${fgGroups}${bgGroups}";
        in {
          required = true;
          source = mkDefault (pkgs.writeShellScript "colorctl" "echo \"${cmd}\" && ${cmd} && echo \"Done\".");
        };
      };

      reloadCommand = "~/.config/chroma/active/neovim/colorctl";
    };
  };
}
