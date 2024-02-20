{ lib, ... }: {
  # Bootloader
  boot.loader = lib.mkForce {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = false;
    };
  };

  boot.initrd.systemd.enable = true;
}