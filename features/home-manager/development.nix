{ origin, pkgs, maxdots, ... }: {
  home.packages = with pkgs; [
    go
    python3
    libsecret
    cargo
    gcc
    gnumake
    openssl
    sqlcmd
  ];
}
