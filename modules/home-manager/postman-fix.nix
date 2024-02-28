{ ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      postman = prev.postman.overrideAttrs(old: rec {
        version = "10.23.5";
        src = final.fetchurl {
          url = "https://dl.pstmn.io/download/version/${version}/linux64";
          sha256 = "sha256-NH5bfz74/WIXbNdYs6Hoh/FF54v2+b4Ci5T7Y095Akw=";

          name = "${old.pname}-${version}.tar.gz";
        };
      });
    })
  ];
}