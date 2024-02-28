{ ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      postman = prev.postman.overrideAttrs(old: rec {
        version = "10.23.5";
        src = final.fetchurl {
          url = "https://dl.pstmn.io/download/version/${version}/linux64";
          sha256 = "sha256-svk60K4pZh0qRdx9+5OUTu0xgGXMhqvQTGTcmqBOMq8=";

          name = "${old.pname}-${version}.tar.gz";
        };
      });
    })
  ];
}