{
  maxdots,
  origin,
  pkgs,
  ...
}: {
  imports = [
    origin.inputs.hyprland.nixosModules.default
  ];

  maxdots.feature.desktop.enable = true;

  programs.hyprland = {
    enable = true;
    package = origin.inputs.hyprland.packages.${pkgs.system}.default;
    portalPackage = origin.inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };
  # xdg-desktop-portal-hyprland is implicitly included by the Hyprland module
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  programs.dconf.enable = true;

  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    nerdfonts
  ];

  # Required to allow swaylock/hyprlock to unlock.
  security.pam.services.swaylock = {};
  security.pam.services.hyprlock = {};

  # Required by end-4's AGS config. I'm not sure what for.
  users.users.max.extraGroups = ["video" "input"];

  # To control backlight via DDC.
  hardware.i2c.enable = true;

  services = {
    gvfs.enable = true;
    devmon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    gnome = {
      glib-networking.enable = true;
    };
  };
}
