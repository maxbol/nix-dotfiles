{
  origin,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.maxdots.feature.autologin;
in {
  featureOptions = {
    defaultUser = lib.mkOption {
      type = lib.types.str;
      description = ''
        The username of the user to be logged in by default
      '';
    };
  };
  config = {
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${origin.inputs.hyprland.packages.${pkgs.system}.default}/bin/Hyprland";
          user = cfg.defaultUser;
        };
        default_session = initial_session;
      };
    };
  };
}
