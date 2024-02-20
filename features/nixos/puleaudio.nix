{...}: {
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = false;
    extraConfig = "
  		load-module module-switch-on-connect
		";
  };
}