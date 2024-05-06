{pkgs, ...}: {
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = false;
    extraConfig = "
  		load-module module-switch-on-connect
		";
    support32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    pulseaudio
    wireplumber
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
}

