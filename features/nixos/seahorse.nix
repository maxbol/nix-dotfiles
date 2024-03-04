{ pkgs, ... }: {
  programs.seahorse.enable = true;

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    gnome.seahorse
  ];
}
