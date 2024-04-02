{
  stdenvNoCC,
  fetchFromGitHub,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "hyprdots-qt5ct";
  src = ./.;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    mv qt5ct $out/share/qt5ct
    runHook postInstall
  '';
}
