{
  stdenvNoCC,
  fetchFromGitHub,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "gruvbox-qt5ct";
  src = fetchFromGitHub {
    owner = "tomekn";
    repo = "config";
    rev = "b7afcc5209bdcdb4f07a1c8fcf911f01550c01e9";
    hash = "sha256-2hMqWe2m7Tx/itRSvn84wA6oSpuLGSbgHLYSEcFAuA0=";
  };
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/qt5ct/colors

    mv qt5ct/colors/oomox-GRUVBOX.conf $out/share/qt5ct/colors/gruvbox.conf
  '';
}
