{...}: {
  config.copper.features = [
    "base"
  ];

  config = {
    system.stateVersion = "24.11";
    services.yabai.enable = true;
    services.sketchybar.enable = true;
  };
}
