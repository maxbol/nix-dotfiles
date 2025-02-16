{
  pkgs,
  config,
  ...
}: {
  copper.file.config."i3/config" = "config/i3/config";
  copper.file.config."i3/scripts" = "config/i3/scripts";
  copper.file.config."polybar" = "config/polybar";
  copper.file.config."picom/picom.conf" = "config/picom/picom.conf";

  home.packages = with pkgs; [
    polybar
    polybar-pulseaudio-control
    i3status
    i3-layout-manager
    xdotool
  ];

  systemd.user.services.polkit-authentication-agent = {
    Unit = {
      Description = "Polkit authentication agent";
      Documentation = "https://gitlab.freedesktop.org/polkit/polkit/";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
      Restart = "always";
      # TODO: dbus activation isn't working for the Gnome or Elementary (Pantheon) Agent for some reason
      #BusName = "org.freedesktop.PolicyKit1.AuthenticationAgent";
    };

    Install.WantedBy = ["sway-session.target"];
  };

  systemd.user.services.chroma-launch = {
    Unit = {
      Description = "Set up theming scripts";
      After = ["graphical-session-pre.target"];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${config.maxdots.chroma.themeDirectory}/active/activate";
      Restart = "always";
    };

    Install.WantedBy = ["sway-session.target"];
  };

  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
  services.picom.enable = true;
}
