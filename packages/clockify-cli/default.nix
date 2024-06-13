{
  pkgs,
  lib,
  ...
}: let
  pname = "clockify-cli";
  version = "0.49.0";
  license = lib.licenses.asl20;
in
  pkgs.buildGoModule {
    inherit pname;
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "lucassabreu";
      repo = "${pname}";
      rev = "v${version}";
      sha256 = "sha256-YsHFu0yq/EGhkSYoeMJMvLx0CbdGupGhgc+lCZWMeZ4=";
    };

    vendorHash = "sha256-TlWQwrMRnRDiKo9JSIAiLiwCQSPj1J7DeWHexXIwvRM=";

    meta = {
      inherit license;
      description = "A command line interface for Clockify";
      homepage = "https://clockify-cli.netlify.app/";
    };
  }
