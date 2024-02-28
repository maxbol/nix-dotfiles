{ config, ... }: let 
  dotfilesDir = config.copper.file.symlink.base;
in {
  imports = [
    ./cli/default.nix
  ];

  programs.zsh.shellAliases = {
    resys = "sudo nixos-rebuild switch --flake ${dotfilesDir}#$(hostname)";
    rehome = "home-manager switch --flake ${dotfilesDir}#$USER@$(hostname)";
  };
}