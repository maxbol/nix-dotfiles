{
  pkgs,
  lib,
  ...
}:
with pkgs; let
  pname = "clockify-cli";
  version = "0.48.2";
in
  buildGoModule {
    inherit pname;
    inherit version;

    src = fetchFromGitHub {
      owner = "lucassabreu";
      repo = "${pname}";
      rev = "v${version}";
      sha256 = "sha256-6DU8rYtrGmaLvCFKQ6Z7BBEdl5AlIRcWKf8Dnvo3R2o=";
    };

    vendorHash = "sha256-TlWQwrMRnRDiKo9JSIAiLiwCQSPj1J7DeWHexXIwvRM=";

    meta = with lib; {
      description = "A command line interface for Clockify";
      license = licenses.asl20;
      homepage = "https://clockify-cli.netlify.app/";
    };
  }
