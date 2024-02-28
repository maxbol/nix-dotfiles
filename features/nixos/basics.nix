{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.openssl
  ];
}