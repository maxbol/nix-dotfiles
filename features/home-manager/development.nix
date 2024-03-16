{
  origin,
  pkgs,
  maxdots,
  ...
}: let
  # Wrap sqlcmd to always use -W, to make output legible in dadbod
  sqlcmdWrapper = pkgs.writeShellScriptBin "sqlcmd" ''
    ${pkgs.sqlcmd}/bin/sqlcmd -W "$@"
  '';
in {
  home.packages = with pkgs; [
    ## Golang
    go
    gopls
    golangci-lint
    gotools

    # Python
    python3

    # Rust
    cargo

    # C/C++
    gcc
    gnumake

    # Nix
    alejandra

    # Global libs/tooling
    openssl
    sqlcmdWrapper
  ];
}
