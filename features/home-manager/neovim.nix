{
  pkgs,
  config,
  lib,
  origin,
  ...
}: let
  hasGit = config.programs.git.enable;

  neovimNoParser = pkgs.neovim-unwrapped.overrideAttrs {
    # Tree sitter is managed by lazy
    treesitter-parsers = {};
  };

  nvim-colorctl = origin.inputs.nvim-colorctl.packages.${pkgs.system}.default;
in {
  # TODO: figure out why smartindent is on (at least for nix files)
  # TODO: fix folding (consider nvim-ufo?)
  # TODO: get debugging to work
  # TODO: fix tree-sitter grammars by installing through home-manager
  # TODO: checkout dropbar.nvim
  # TODO: git blame in nvim?
  home.sessionVariables.EDITOR = "nv";
  programs.neovim.enable = true;
  programs.neovim.package = neovimNoParser;
  programs.neovim.extraPackages = with pkgs; [
    tree-sitter
    imagemagick
    # Needed by our configuration
    fd
    ripgrep
    luajit # Used by some neovim packages
  ];
  programs.neovim.extraLuaPackages = ps: [ps.magick];

  home.packages = with pkgs; [
    # Scipt to treat a directory argument as the working directory
    pkgs.neovim-remote
    nvim-colorctl
    (writeShellScriptBin "nv" ''
      pushd () {
          command pushd "$@" > /dev/null
      }

      popd () {
          command popd "$@" > /dev/null
      }

      git_dir() {
        ${
        if hasGit
        then ''          if git rev-parse --show-toplevel > /dev/null 2>&1; then
                    cd $(git rev-parse --show-toplevel)
                fi''
        else ""
      }
      }

      arg_len=$(($#-1))

      if [ "$arg_len" -gt "-1" ]; then
        last_arg="''${@:-1}"
        other_args="''${@:1:$length}"

        if test -d $last_arg; then
          pushd $1
          nvim $other_args .
          popd
        elif test -f $last_arg; then
          file=$(realpath $last_arg)
          pushd $(dirname $last_arg)
          git_dir
          nvim $other_args $file
          popd
        else
          nvim $@
        fi
      else
        git_dir
        nvim .
      fi
    '')
  ];

  # home.file.".config/nvim/parser".source = "${treesitter-parsers}/parser";
  copper.file.config."nvim" = "config/nvim";
}
