{ ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      notion-app-enhanced = prev.notion-app-enhanced.overrideAttrs(old: rec {
        version = "2.0.16";
        src = final.fetchurl {
          url = "https://github.com/notion-enhancer/notion-repackaged/releases/download/v${version}/Notion-Enhanced-${version}.AppImage";
          sha256 = "sha256-4mNRE5KFCdxmNold5icsMqYjxsJBKH8ht1H8UEfr/u4=";
        };
      });
    })
  ];
}
