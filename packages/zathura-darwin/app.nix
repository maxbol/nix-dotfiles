{
  runCommand,
  writeText,
  zathuraExe,
}: let
  wflow = import ./workflow.nix {inherit writeText zathuraExe;};
  zathura-client-app = ./src;
in
  runCommand "zathura-client-app" {} ''
    mkdir -p $out/Applications
    cp -r ${zathura-client-app} $out/Applications/zathura-client.app
    chmod -R 744 $out/Applications/zathura-client.app
    ln -s ${wflow} $out/Applications/zathura-client.app/Contents/document.wflow
  ''
