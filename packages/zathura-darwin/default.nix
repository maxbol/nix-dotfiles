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
        inherit runCommand writeText;
        zathuraExe = lib.getExe zathura;
      }
    )
  ];
}
