{
  symlinkJoin,
  writeShellApplication,
  hyprland,
  gnused,
  gawk,
  rofi-wayland,
  dunst,
  dconf,
  cliphist,
  self,
  inputs,
  lib,
  ...
}: let
  inherit (inputs.copper.packages) swimctl chromactl nailgun;
in symlinkJoin {
  name = "rofi-launcher-hyprdots-swwwallselect-patch";
  paths = builtins.map (f:
    writeShellApplication {
      name = f;
      runtimeInputs = [
        hyprland
        gnused
        gawk
        rofi-wayland
        dunst
        dconf
        cliphist
        swimctl
        chromactl
        nailgun
      ];
      checkPhase = "";
      text = builtins.readFile "${./src}/${f}";
    }) (builtins.attrNames (builtins.readDir ./src));
}
