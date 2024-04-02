{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  ...
}: let
  pname = "gruvbox-kvantum";
in
  stdenvNoCC.mkDerivation {
    inherit pname;
    version = "unstable-2024-03-31";

    src = fetchFromGitHub {
      owner = "theglitchh";
      repo = "Gruvbox-Kvantum";
      rev = "be75efd4d4a13589fb411e679498943b2dd2380f";
      sha256 = "sha256-2pUvvZeCa51zA+cZJWGo62Zo21tER+cCcaFA5HUNtjM=";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/Kvantum
      cp -a gruvbox-kvantum $out/share/Kvantum
      runHook postInstall
    '';

    meta = with lib; {
      description = "Gruvbox theme for Kvantum";
      homepage = "https://github.com/theglitchh/Gruvbox-Kvantum";
    };
  }
