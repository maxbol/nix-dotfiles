{
  origin,
  config,
  maxdots,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) foldl';
  nvimDir = "${config.xdg.configHome}/nvim";

  bindNvChadFile = file: {
    "${nvimDir + file}".source = maxdots.packages.nvchad + file;
  };

  bindNvChadFiles = files: foldl' (acc: elem: acc // (bindNvChadFile elem)) {} files;

  nvChadFiles = [
    "/init.lua"
    "/LICENSE"
    "/lua/core"
    "/lua/plugins"
  ];

  defaultUiLua = pkgs.writeText "default-ui.lua" ''
    return function(highlights)
      local M = {
        theme = "gruvchad",
        hl_override = highlights.override,
        hl_add = highlights.add,
      }

      return M
    end
  '';

  fileBindings =
    bindNvChadFiles nvChadFiles;

  cfg = config.programs.nvchad;
in {
  options = with lib; {
    programs.nvchad = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      uiLua = mkOption {
        type = types.str;
        default = defaultUiLua;
      };
    };
  };

  imports = let
    finalFileBindings =
      fileBindings
      // {
        "${nvimDir}/lua/ui.lua".source = config.lib.file.mkOutOfStoreSymlink "${cfg.uiLua}";
      };
  in [
    (lib.mkIf cfg.enable {
      home.file = finalFileBindings;
      copper.file.config."nvim/lua/custom" = "config/nvchad-custom";
      home.packages = with pkgs; [
        neovim
        origin.inputs.nixd.packages.${pkgs.system}.nixd
        stylua
        lua-language-server
      ];
    })
  ];
}
