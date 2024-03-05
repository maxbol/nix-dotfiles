{
  origin,
  ...
}: {
  imports = [
    origin.inputs.nh.nixosModules.default
  ];

  nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  environment.sessionVariables.FLAKE = "/home/max/dotfiles/";
}
