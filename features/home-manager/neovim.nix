{
  pkgs,
  config,
  lib,
  ...
}: let
  hasGit = config.programs.git.enable;

  neovimNoParser = pkgs.neovim-unwrapped.overrideAttrs {
    # Tree sitter is managed by lazy
    treesitter-parsers = {};
  };
in {
  # TODO: figure out why smartindent is on (at least for nix files)
  # TODO: fix folding (consider nvim-ufo?)
  # TODO: get debugging to work
  # TODO: fix tree-sitter grammars by installing through home-manager
  # TODO: checkout dropbar.nvim
  # TODO: git blame in nvim?
  home.sessionVariables.EDITOR = "nv";
  # programs.neovim.enable = true;
  # programs.neovim.extraPackages = with pkgs; [
  #   # Needed by our configuration
  #   fd
  #   ripgrep
  #
  #   luajit # Used by some neovim packages
  # ];

  home.packages = with pkgs; [
    neovimNoParser
    # Scipt to treat a directory argument as the working directory
    (writeShellScriptBin "nv" ''
      if test -d $1; then
          pushd $1
          nvim .
      else
          file=$(realpath $1)
          pushd $(dirname $1)
          ${
        if hasGit
        then ''          if git rev-parse --show-toplevel; then
                      cd $(git rev-parse --show-toplevel)
                  fi''
        else ""
      }
          nvim $file
      fi
      popd
    '')
  ];

  # home.file.".config/nvim/parser".source = "${treesitter-parsers}/parser";
  copper.file.config."nvim-pure" = "config/nvim";
  xdg.configFile."nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/nvim-pure/lua";
  xdg.configFile."nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/nvim-pure/init.lua";
  xdg.configFile."nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/nvim-pure/lazy-lock.json";
}
