{
  origin,
  pkgs,
  config,
  ...
}: let
  cfg = config.maxdots.feature.nixos.autologin;
in {
  featureOptions = {
    defaultUser = pkgs.mkOption {
      type = pkgs.types.str;
      description = ''
        The username of the user to be logged in by default
      '';
    };
  };
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
}
