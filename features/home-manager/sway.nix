{
  # options,
  pkgs,
  config,
  copper,
  ...
}: {
  copper.file.config."sway/config" = "config/sway/config";
  copper.file.config."sway/scripts" = "config/sway/scripts";

  # wayland.windowManager.sway = {
  #   enable = true;
  #   systemd.enable = true;
  #
  #   systemd.variables =
  #     options.wayland.windowManager.sway.systemd.variables.default
  #     ++ [
  #       "XDG_DATA_DIRS"
  #       "XDG_CONFIG_DIRS"
  #       "PATH"
  #     ];
  #
  #   settings.source = ["${config.xdg.configHome}/sway/config"];
  # };

  home.packages = with pkgs; [
    copper.packages.systemctl-toggle
    xwaylandvideobridge
    procps
    wl-clipboard
    wl-clipboard-x11
    swaylock
    swayidle
    brightnessctl
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
      ExecStart = "${config.copper.chroma.themeDirectory}/active/activate";
      Restart = "always";
    };

    Install.WantedBy = ["sway-session.target"];
  };

  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
}
