{ lib, ... }: {
  # Bootloader
  boot.loader = lib.mkForce {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = null;
    timeout = 5;
    systemd-boot.enable = false;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = false;
    };
  };

  boot.initrd.systemd.enable = true;
}
