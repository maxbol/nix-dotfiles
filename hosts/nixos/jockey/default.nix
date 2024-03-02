# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ origin, config, pkgs, lib, ... }:

{
  imports =
    [
      # Incluse results of the hardware scan
      ./hardware-configuration.nix
    ];

  # Manually turn of bluetooth - USB adapter
  config.hardware.bluetooth.enable = true;

  config.copper.features = [
    "_1password"
    "nvidia"
    "quiet-boot"
  ];

  config.maxdots.features = [
    "audio"
    "basics"
    "bluetooth"
    "docker"
    "flatpak"
    "fonts"
    "gc"
    "grub"
    "hid-apple"
    "home-manager"
    "hyprland"
    "locale-se"
    "openssh"
    #"plymouth" #
    "sops"
    "syncthing"
    "tailscale"
    "wayland"
    "xserver-misc"
  ];

  config.networking.hostName = "jockey"; # Change your hostname.

  config.users.users.max = {
    isNormalUser = true;
    description = "Max Bolotin";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # Enable networking
  config.networking.networkmanager.enable = true;

  # No firwall for now, will switch when real install
  config.networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  config.system.stateVersion = lib.mkForce "23.11"; # Did you read the comment?
}


