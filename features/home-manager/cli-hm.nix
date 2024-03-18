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

  programs.zsh.shellAliases = {
    rehome = "home-manager switch --flake ${dotfilesDir}#$USER@$(hostname)";
  };
}
