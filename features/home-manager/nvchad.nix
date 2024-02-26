{ config, maxdots, pkgs, ... }: let
  nvimDir = "${config.xdg.configHome}/nvim";
in {
  home.file.${nvimDir} = maxdots.packages.nvchad;
  copper.file.config."nvim/lua/custom" = "config/nvchad-custom";

  home.packages = [pkgs.neovim];
}