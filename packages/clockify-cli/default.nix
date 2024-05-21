{
  pkgs,
  lib,
  ...
}:
with pkgs; let
  pname = "clockify-cli";
  version = "0.49.0";
in
  buildGoModule {
    inherit pname;
    inherit version;

    src = fetchFromGitHub {
      owner = "lucassabreu";
      repo = "${pname}";
      rev = "v${version}";
      sha256 = "sha256-YsHFu0yq/EGhkSYoeMJMvLx0CbdGupGhgc+lCZWMeZ4=";
    };

    vendorHash = "sha256-TlWQwrMRnRDiKo9JSIAiLiwCQSPj1J7DeWHexXIwvRM=";

    meta = with lib; {
      description = "A command line interface for Clockify";
      license = licenses.asl20;
      homepage = "https://clockify-cli.netlify.app/";
    };
  }
