{
  lib,
  stdenv,
  pkgs,
  copper,
  config,
  ...
}:
stdenv.mkDerivation rec {
  pname = "nvchad";
  version = "6833c60694a626615911e379d201dd723511546d";

  src = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "6833c60694a626615911e379d201dd723511546d";
    # rev = "refs/heads/v${version}";
    # rev = "32b0a008a96a3dd04675659e45a676b639236a98";
    # sha256 = "sha256-s/nnGUGFgJ+gpMAOO3hYJ6PrX/qti6U1wyB6PzTiNtM=";
    sha256 = "sha256-xmP3zdw5Q5YyyZkLNDFPouOM+G6NwbroGxXOmSmlS3A=";
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
