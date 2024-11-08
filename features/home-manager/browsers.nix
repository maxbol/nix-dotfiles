{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    google-chrome
    firefox
    microsoft-edge
    floorp
  ];
}
