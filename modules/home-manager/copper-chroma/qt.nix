{
  pkgs,
  lib,
  ...
}: {
  copper.chroma.programs.qt.activationCommand =
    lib.mkForce
    ({
      name,
      opts,
    }: "${pkgs.kdePackages.qtstyleplugin-kvantum}/bin/kvantummanager --set ${opts.kvantum.name}");
}
