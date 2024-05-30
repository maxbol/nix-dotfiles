{
  stdenv,
  fetchurl,
  temurin-jre-bin-17,
  makeWrapper,
  ...
}:
stdenv.mkDerivation rec {
  name = "dbvisualizer";

  version = "24.1.5";

  src = fetchurl {
    url = "https://www.dbvis.com/product_download/dbvis-${version}/media/dbvis_linux_24_1_5.tar.gz";
    hash = "sha256-zrvR5YiEoFtmUbG01ntWvOT0Xd7NGvlVpeVnxrIt6oQ=";
  };

  buildInputs = [makeWrapper];

  installPhase = ''
    mkdir -p $out/bin
    cp -a . $out
    wrapProgram $out/dbvis --set INSTALL4J_JAVA_HOME ${temurin-jre-bin-17}
    ln -sf $out/dbvis $out/bin
  '';

  meta = {
    description = "The universal database tool";
    homepage = "https://www.dbvis.com/";
    # license = lib.licenses.unfree;
  };
}
