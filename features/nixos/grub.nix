{lib, ...}: {
  # Bootloader
  boot.loader = lib.mkForce {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    timeout = 5;
    systemd-boot.enable = false;
    grub = {
      enable = true;
      gfxmodeEfi = "5120x1440";
      gfxmodeBios = "5120x1440";
      device = "nodev";
      efiSupport = true;
      useOSProber = false;
    };
  };

  boot.initrd.systemd.enable = true;
}
