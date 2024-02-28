{
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
  };
  # xdg-desktop-portal-hyprland is implicitly included by the Hyprland module
  #xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  programs.dconf.enable = true;

  services.blueman.enable = true;

  services.xserver.displayManager.sddm = {
    theme = "corners";
    # This is a fix for a huge onscreen keyboard appearing and hiding everything.
    settings.General.InputMethod = "";
  };
  environment.systemPackages = with pkgs; [
    nerdfonts
  ];

  # Required to allow swaylock to unlock.
  security.pam.services.swaylock = {};
}
