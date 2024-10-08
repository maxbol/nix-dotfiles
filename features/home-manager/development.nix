{
  origin,
  pkgs,
  maxdots,
  lib,
  ...
}: let
  withGoRootWrapper = pkg: binName:
    pkgs.writeShellScriptBin binName ''
      export GOROOT=${pkgs.go}
      ${lib.getExe pkg} $*
    '';

  # Wrap sqlcmd to make output legible in dadbod
  sqlcmd = pkgs.writeShellScriptBin "sqlcmd" ''
    ${pkgs.sqlcmd}/bin/sqlcmd -w 200 -Y 36 "$@"
  '';

  swag = withGoRootWrapper pkgs.go-swag "swag";

  # Non-nixpkgs packages
  nancy = maxdots.packages.nancy;
  zig = origin.inputs.zig-overlay.packages.${pkgs.system}.default;
  zls = origin.inputs.zls.packages.${pkgs.system}.default;
  nixd = origin.inputs.nixd.packages.${pkgs.system}.nixd;
in {
  home.packages =
    (with pkgs; [
      # NodeJS
      nodejs
      yarn
      yarn2nix
      vscode-langservers-extracted
      nodePackages.fixjson
      nodePackages.ts-node
      asdf
      asdf-vm

      # Golang
      go
      gopls
      golangci-lint
      golangci-lint-langserver
      gotools

      # Protobuffers
      buf-language-server

      # Rust
      cargo

      # C/C++
      gcc
      gnumake
      clang-tools_18
      # vscode-extensions.llvm-org.lldb-vscode
      llvm_18
      lldb_18
      tracy

      # Swift
      sourcekit-lsp

      # CSharp
      dotnet-sdk_8
      omnisharp-roslyn
      csharpier
      netcoredbg

      # Nix
      alejandra

      # Lua
      stylua
      lua-language-server
      luau

      # Python
      # (python3.withPackages
      #   (ps: [
      #     ps.pyyaml
      #     ps.pip
      #   ]))
      # pipx

      # Docker
      hadolint
      dockerfile-language-server-nodejs
      docker-compose-language-service
      grype

      # Version management tooling
      lazygit
      gh

      # Package management, virtualisation, environments, etc
      # origin.inputs.devenv.packages.${pkg.system}.devenv
      devenv

      # Global libs/tooling
      openssl
      silicon
      mdcat

      # Low level tools
      lsof
      # netcat-openbsd
      procps
    ])
    ++ [
      # Wrappers, custom and non-nixpkgs packages
      sqlcmd
      nancy
      swag
      zig
      zls
      nixd
    ];
}
