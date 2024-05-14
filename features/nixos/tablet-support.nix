{pkgs, ...}: {
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
  environment.systemPackages = [pkgs.opentabletdriver];
}
