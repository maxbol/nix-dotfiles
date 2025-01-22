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
  synp = maxdots.packages.synp;
  zig = origin.inputs.zig-overlay.packages.${pkgs.system}.default;
  zls = origin.inputs.zls.packages.${pkgs.system}.default;

  ccjson = pkgs.writeShellScriptBin "ccjson" ''
    make --always-make --dry-run \
     | grep -wE 'clang|gcc|g\+\+' \
     | grep -w '\-c' \
     | jq -nR '[inputs|{directory:".", command:., file: match(" [^ ]+$").string[1:]}]' \
     > compile_commands.json
  '';
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
      buf

      # Rust
      cargo
      rust-analyzer

      # Odin
      odin
      ols

      # C/C++
      gcc
      gnumake
      checkmake
      llvm_17
      lldb_17
      tracy
      bear
      meson
      ninja
      # gdb ## Only available on linux

      #OCaml
      ocaml
      dune_3
      ocamlPackages.ocaml-lsp
      ocamlPackages.earlybird

      # Swift
      sourcekit-lsp

      # CSharp
      dotnet-sdk_8
      omnisharp-roslyn
      csharpier
      netcoredbg

      # Nix
      alejandra
      nixd

      # Lua
      stylua
      lua-language-server
      lua5_1
      luau
      luarocks

      # Gleam
      gleam

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
      # procps
    ])
    ++ [
      # Wrappers, custom and non-nixpkgs packages
      ccjson
      nancy
      sqlcmd
      swag
      synp
      zig
      zls
    ];
}
