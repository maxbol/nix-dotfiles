{ pkgs, ... }: {
  home.packages = with pkgs; [
    nodejs
    yarn
    yarn2nix
    vscode-langservers-extracted
  ];
}
