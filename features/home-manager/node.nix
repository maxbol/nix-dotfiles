{ pkgs, ... }: {
  home.packages = with pkgs; [
    nodejs
    yarn
    yarn-berry
    yarn2nix
  ];
}