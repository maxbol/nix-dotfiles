{
  mkYarnPackage,
  fetchFromGitHub,
  lib,
  ...
}:
mkYarnPackage rec {
  name = "synp";
  pname = "synp";
  version = "1.9.13";
  src = fetchFromGitHub {
    owner = "imsnif";
    repo = "synp";
    rev = "v${version}";
    sha256 = "sha256-7FTpixi0EpRk/JuFhbZP666//4o6/1qODgAteZST3RM=";
  };

  meta = {
    description = "Convert yarn.lock to package-lock.json and vice versa.";
    homepage = "https://github.com/imsnif/synp";
    license = lib.licenses.mit;
  };
}
