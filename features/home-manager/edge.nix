{ pkgs, ... }: {
  home.packages = with pkgs; [
    microsoft-edge
  ];
}
