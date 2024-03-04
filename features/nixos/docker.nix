{ pkgs, ... }: {
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
