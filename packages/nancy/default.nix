{
  buildGoModule,
  fetchFromGitHub,
  go,
  lib,
  ...
}:
buildGoModule {
  name = "nancy";

  src = fetchFromGitHub {
    owner = "sonatype-nexus-community";
    repo = "nancy";
    rev = "6d5e5ff671efbf809300cfef468dd8baba26d5c2";
    sha256 = "sha256-jg+R5p0mEDuDznq+MK1RgKH1WT8nMaU862y83ha+bbk=";
  };

  vendorHash = "sha256-+8U38Ia6mehbcVE2k4D+0h6TyN40Ksufgs8aMpqUBXw=";

  buildInputs = [
    go
  ];

  buildPhase = ''
    make build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp nancy $out/bin/nancy
  '';

  meta = {
    description = "A tool to check for vulnerabilities in your Golang dependencies";
    homepage = "https://github.com/sonatype-nexus-community/nancy";
    license = lib.licenses.asl20;
  };
}
