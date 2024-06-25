{pkgs, ...}: {
  copper.feature.desktop.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  programs.dconf.enable = true;

  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    nerdfonts
  ];

  security.pam.services.swaylock = {};
  security.pam.services.hyprlock = {};

  users.users.max.extraGroups = ["video" "input"];

  hardware.i2c.enable = true;

  services = {
    gvfs.enable = true;
    devmon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      glib-networking.enable = true;
    };
  };
}
