{ appimageTools, makeDesktopItem, fetchurl, makeWrapper, symlinkJoin, ... }: let
  name = "texts";
  version = "0.83.0";
  hash = "d93049b1a1";

  texts = appimageTools.wrapType2 {
    inherit name;

    src = fetchurl {
      url = "https://texts-binaries.texts.com/builds/Texts-Linux-x64-v${version}-${hash}.AppImage";
      hash = "sha256-iuZDv/RIxRewBsrWOI55DyIQm3Q7HeB9movWEAKI13k=";
      curlOptsList = ["-HUser-Agent: curl/8.6.0" "-HAccept: */*"];
    };
    
    extraPkgs = pkgs: with pkgs; [libsecret];
  };

  texts-desktop = makeDesktopItem {
     name = "texts";
     exec = "${texts}/bin/texts %U";
     icon = "texts";
     desktopName = "Texts.com";
     comment = "The ultimate messaging app";
     mimeTypes = [ "x-scheme-handler/texts" ];
     categories = [ "Network" ];
     startupWMClass = "texts";
   };
in symlinkJoin {
  inherit name;
  inherit version;

  buildInputs = [
    makeWrapper
  ];

  paths = [texts texts-desktop];

  postInstall = ''
    mkdir $out/lib/texts
    mv $out/bin/texts $out/lib/texts/texts

    makeWrapper $out/lib/texts/texts $out/bin/texts \
      --add-flags "--disable-gpu --disable-gpu-compositing --disable-software-rasterizer"
  '';
}
