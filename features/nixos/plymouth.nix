{ pkgs, ... }: {
  boot.initrd.systemd.enable = true;
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };
  boot.kernelParams = [
    "quiet"
  ];

  environment.systemPackages = with pkgs; [
    plymouth
    breeze-plymouth
  ];
}