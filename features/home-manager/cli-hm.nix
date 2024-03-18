{
  config,
  maxdots,
  ...
}: let
  dotfilesDir = config.copper.file.symlink.base;
in {
  imports = [
    ./cli/default.nix
  ];

  home.packages = with maxdots.packages; [
    clockify-cli
  ];

  programs.zsh.shellAliases = {
    rehome = "home-manager switch --flake ${dotfilesDir}#$USER@$(hostname)";
  };
}

