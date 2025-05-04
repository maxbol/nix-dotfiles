{
  pkgs,
  # config,
  # lib,
  origin,
  ...
}: let
  # hasGit = config.programs.git.enable;
  # neovim-unwrapped = origin.inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.neovim-unwrapped.overrideAttrs {
  #   # TS Parsers are installed through Lazy.vim
  #   treesitter-parsers = {};
  # };
  # neovim-unwrapped = pkgs.neovim-unwrapped.overrideAttrs {
  #   # TS Parsers are installed through Lazy.vim
  #   treesitter-parsers = {};
  # };
  neovim-unwrapped = origin.inputs.neovim-nightly-overlay.packages.${pkgs.system}.default.overrideAttrs {
    # TS Parsers are installed through Lazy.vim
    treesitter-parsers = {};
  };
  nvim-colorctl = origin.inputs.nvim-colorctl.packages.${pkgs.system}.default;
  # nv = writeShellScriptBin "nv" ''
  #   pushd () {
  #       command pushd "$@" > /dev/null
  #   }
  #
  #   popd () {
  #       command popd "$@" > /dev/null
  #   }
  #
  #   git_dir() {
  #     ${
  #     if hasGit
  #     then ''        if git rev-parse --show-toplevel > /dev/null 2>&1; then
  #                 cd $(git rev-parse --show-toplevel)
  #             fi''
  #     else ""
  #   }
  #   }
  #
  #   arg_len=$(($#-1))
  #
  #   if [ "$arg_len" -gt "-1" ]; then
  #     last_arg="''${@:-1}"
  #     other_args="''${@:1:$length}"
  #
  #     if test -d $last_arg; then
  #       pushd $1
  #       nvim $other_args .
  #       popd
  #     elif test -f $last_arg; then
  #       file=$(realpath $last_arg)
  #       pushd $(dirname $last_arg)
  #       git_dir
  #       nvim $other_args $file
  #       popd
  #     else
  #       nvim $@
  #     fi
  #   else
  #     git_dir
  #     nvim .
  #   fi
  # '';
in {
  home.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;
    package = neovim-unwrapped;
    extraPackages = with pkgs; [
      tree-sitter
      imagemagick
      # Needed by our configuration
      fd
      ripgrep
      luajit # Used by some neovim packages

      # For Copilot chat
      luajitPackages.tiktoken_core
    ];
    extraLuaPackages = ps: [ps.magick];
  };

  programs.zsh.shellAliases = {
    nv = "nvim";
  };

  home.packages = with pkgs; [
    # Scipt to treat a directory argument as the working directory
    neovim-remote
    nvim-colorctl
  ];

  # home.file.".config/nvim/parser".source = "${treesitter-parsers}/parser";
  copper.file.config."nvim" = "config/nvim";
}
