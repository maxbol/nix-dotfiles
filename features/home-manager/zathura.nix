{
  maxdots,
  lib,
  pkgs,
  ...
}: let
  zathura-darwin = maxdots.packages.zathura-darwin;
  zathura-darwin-app = maxdots.packages.zathura-darwin-app;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin == true;
in
  lib.mkMerge [
    {
      programs.zathura = {
        enable = true;
        package =
          if isDarwin
          then zathura-darwin
          else pkgs.zathura;
      };
    }
    (lib.mkIf isDarwin {
      home.activation.copyZathuraApp = let
        dest = "$HOME/Applications/zathura-darwin.app";
      in
        lib.hm.dag.entryAfter ["linkGeneration"] ''
          rm -rf $HOME/Applications/zathura-client.app
          cp -LR ${zathura-darwin-app}/Applications/zathura-darwin.app ${dest}
          chmod -R ug+rwx ${dest}
        '';
    })
  ]
