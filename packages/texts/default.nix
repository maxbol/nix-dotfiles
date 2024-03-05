{ appimageTools, makeDesktopItem, fetchurl, ... }: let
  name = "texts";
  version = "0.83.0";
  hash = "d93049b1a1";
in appimageTools.wrapType2 {
  inherit name;

  src = fetchurl {
    url = "https://texts-binaries.texts.com/builds/Texts-Linux-x64-v${version}-${hash}.AppImage";
    hash = "sha256-iuZDv/RIxRewBsrWOI55DyIQm3Q7HeB9movWEAKI13k=";
    curlOptsList = ["-HUser-Agent: curl/8.6.0" "-HAccept: */*"];
  };  

  #desktopItems = [
  #  (makeDesktopItem {
  #    name = "texts";
  #    exec = "texts %U";
  #    icon = "texts";
  #    desktopName = "Texts.com";
  #    comment = "Universal messaging application";
  #    mimeTypes = [ "x-scheme-handler/texts" ];
  #    categories = [ "Messaging" ];
  #    startupWMClass = "texts";
  #  })
  #];

  extraPkgs = pkgs: with pkgs; [libsecret];
}
