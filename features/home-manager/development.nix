{ origin, pkgs, maxdots, ... }: {
  home.packages = with pkgs; [
    go
    python3
    postman
    libsecret
    cargo
    gcc
  ];
}
