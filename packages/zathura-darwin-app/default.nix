{
  lib,
  runCommand,
  writeText,
  self,
  symlinkJoin,
  ...
}: let
  zathura = self.zathura-darwin;
in
  symlinkJoin {
    name = "zathura-darwin-app";
    version = "git";
    paths = [
      zathura
      (
        import
        ./app.nix
        {
          inherit runCommand writeText;
          zathuraExe = lib.getExe zathura;
        }
      )
    ];
  }
