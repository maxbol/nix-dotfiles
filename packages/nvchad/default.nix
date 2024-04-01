{
  lib,
  stdenv,
  pkgs,
  copper,
  config,
  ...
}:
stdenv.mkDerivation {
  pname = "nvchad";
  version = "2.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "refs/heads/v2.0";
    sha256 = "sha256-N+Ftw/Poylv2+9QKoteDbKzjB5aOy7NjDRICEmSvsAw=";
  };

  installPhase = ''
    mkdir $out
    cp -r * "$out/"
  '';

  meta = with lib; {
    description = "NvChad";
    homepage = "https://github.com/NvChad/NvChad";
    platforms = platforms.all;
  };
}
