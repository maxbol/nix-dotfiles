{
  lib,
  runCommand,
  symlinkJoin,
  writeText,
  zathura,
  ...
}:
symlinkJoin {
  name = "zathura-darwin";
  paths = [
    zathura
    (
      import
      ./app.nix
      {
        inherit lib runCommand writeText;
        zathuraExe = lib.getExe zathura;
      }
    )
  ];
}
