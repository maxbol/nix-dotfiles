{ origin, config, maxdots, pkgs, lib, ... }: let
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

  fileBindings = bindNvChadFiles nvChadFiles;
in {
  home.file = fileBindings;
  copper.file.config."nvim/lua/custom" = "config/nvchad-custom";
  home.packages = [pkgs.neovim origin.inputs.nixd.packages.${pkgs.system}.nixd pkgs.stylua];
}
