{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  ...
}: let
  pname = "hyprdots-kvantum";
in
  stdenvNoCC.mkDerivation {
    inherit pname;
    version = "unstable-2024-03-31";

    src = ./.;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share
      cp -R src $out/share/Kvantum
      runHook postInstall
    '';

    meta = with lib; {
      description = "Hyprdots themes for Kvantum";
      homepage = "https://github.com/prasanthrangan/hyprdots";
    };
  }
