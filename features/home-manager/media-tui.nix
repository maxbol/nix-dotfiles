{pkgs, ...}: let
in {
  home.packages = with pkgs; [
    (spotify-player.override
      {
        withImage = true;
        withLyrics = true;
      })
    spicetify-cli
  ];
}
