{
  pkgs,
  modulesPath,
  ...
}: {
  config.nixpkgs.hostPlatform = "x86_64-linux";
  config.system.stateVersion = "24.11";

  imports = [
    # Incluse results of the hardware scan
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  # Manually turn of bluetooth - USB adapter
  config.hardware.bluetooth.enable = true;

  config.copper.features = [];

  config.copper.feature.hyprland.enable = false;
  config.copper.feature.base.enable = false;

  config.maxdots.features = [
    "audio"
    "basics"
    "bluetooth"
    "desktop"
    "docker"
    "flatpak"
    "fonts"
    "grub"
    "hid-apple"
    "home-manager"
    "locale-se"
    # "nh"
    "sddm"
    "seahorse"
    "sops"
    "udev"
    "wayland"
    # "hyprland"
    #"plymouth" #
  ];

  config.networking.hostName = "seedling";

  config.users.groups.docker = {};
  config.users.groups.plugdev = {};

  config.users.users.max = {
    isNormalUser = true;
    description = "Max Bolotin";
    extraGroups = ["networkmanager" "wheel" "docker" "plugdev"];
    packages = [];
    shell = pkgs.zsh;
  };

  config.networking.firewall.enable = false;

  config.programs.zsh.enable = true;
}
