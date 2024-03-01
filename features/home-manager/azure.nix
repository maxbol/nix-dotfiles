{ pkgs, ... }:

{
  home.packages = with pkgs; [
    azure-cli
    kubectl
    kubeseal
    azuredatastudio
  ];
}
