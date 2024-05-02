{
  lib,
  config,
  pkgs,
  options,
  copper,
  origin,
  ...
} @ opts: {
  copper.file.config = lib.genAttrs [
    "hypr/hypridle.conf"
    "hypr/hyprlock.conf"
    "hypr/animations.conf"
    "hypr/entry.conf"
    "hypr/keybindings.conf"
    "hypr/nvidia.conf"
    "hypr/plugins.conf"
    "hypr/windowrules.conf"
  ] (n: "config/${n}");
  wayland.windowManager.hyprland = {
    enable = true;
    # TODO: this also installs a hyprland package, how does this conflict with the global install
    package = origin.inputs.hyprland.packages.${pkgs.system}.default;
    plugins = [
      origin.inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      # ...
    ];
    systemd.enable = true;
    # Needed so that waybar, etc. have a complete environment
    systemd.variables =
      options.wayland.windowManager.hyprland.systemd.variables.default
      ++ [
        "XDG_DATA_DIRS"
        "XDG_CONFIG_DIRS"
        "PATH"
      ];
    # TODO: nvidia patches are no longer needed, but does that extend to the nvidia conf file?
    settings.source = lib.mkMerge [(lib.mkIf false ["${config.xdg.configHome}/hypr/nvidia.conf"]) ["${config.xdg.configHome}/hypr/entry.conf"]];
  };

  home.packages = with pkgs; [
    copper.packages.systemctl-toggle
    copper.packages.misc-scripts-hyprdots
    xwaylandvideobridge
    procps
    wl-clipboard
    wl-clipboard-x11
    hyprlock
    hypridle
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

    Install.WantedBy = ["hyprland-session.target"];
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

    Install.WantedBy = ["hyprland-session.target"];
  };

  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
}
