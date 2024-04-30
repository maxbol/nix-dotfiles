{config, ...}: {
  # Nvidia drivers are unfree software, if we want to use them, we must allow unfree
  nixpkgs.config.allowUnfree = true;

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      forceFullCompositionPipeline = true;
      powerManagement.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  services.xserver = {
    enable = true;
    exportConfiguration = true;
    videoDrivers = ["nvidia"];
  };
}

