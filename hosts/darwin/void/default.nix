{lib, ...}: {
  # config.copper.features = [
  #   "base"
  # ];

  config = {
    copper.feature.base.enable = lib.mkForce false;
    copper.features = [];

    nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";
    system.stateVersion = "24.11";

    services = {
      aerospace = {
        enable = true;
      };
      sketchybar = {
        enable = true;
      };
      jankyborders = {
        enable = true;
      };
    };
  };
}
