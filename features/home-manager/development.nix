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
    maxdots.packages.nancy

    # Rust
    cargo

    # C/C++
    gcc
    gnumake

    # Nix
    alejandra
    origin.inputs.nixd.packages.${pkgs.system}.nixd

    # Lua
    stylua
    lua-language-server

    # Python
    (python3.withPackages
      (ps: [
        ps.pyyaml
        ps.pip
      ]))
    pipx

    # Package management, virtualisation, environments, etc
    origin.inputs.devenv.packages.${pkg.system}.devenv

    # Vulnerability scanning
    grype

    # Global libs/tooling
    openssl
    sqlcmdWrapper
    silicon
    mdcat

    # Low level tools
    lsof
  ];
}
