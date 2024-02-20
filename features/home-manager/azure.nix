{ pkgs, ... }:

{
  home.packages = with pkgs; [
    azure-cli
    kubectl
    azuredatastudio
  ];
}
