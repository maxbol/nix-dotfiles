{
  runCommand,
  writeText,
  zathuraExe,
}: let
  wflow = import ./workflow.nix {inherit writeText zathuraExe;};
  zathura-darwin-app = ./src;
in
  runCommand "zathura-darwin-app" {} ''
    mkdir -p $out/Applications
    cp -RL ${zathura-darwin-app} $out/Applications/zathura-darwin.app
    chmod -R 744 $out/Applications/zathura-darwin.app
    ln -s ${wflow} $out/Applications/zathura-darwin.app/Contents/document.wflow
  ''
