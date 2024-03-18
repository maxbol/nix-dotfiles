{
  origin,
  pkgs,
  maxdots,
  ...
}: let
  # Wrap sqlcmd to make output legible in dadbod
  sqlcmdWrapper = pkgs.writeShellScriptBin "sqlcmd" ''
    ${pkgs.sqlcmd}/bin/sqlcmd -w 200 -Y 36 "$@"
  '';
in {
  home.packages = with pkgs; [
    # NodeJS
    nodejs
    yarn
    yarn2nix
    vscode-langservers-extracted
    nodePackages.fixjson

    # Golang
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
