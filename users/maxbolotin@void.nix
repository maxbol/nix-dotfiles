{
  modules = [
    ({
      pkgs,
      lib,
      origin,
      ...
    }: let
      inputsToRegistry = lib.attrsets.mapAttrs (_: input: {
        flake = input;
      });
    in {
      home.stateVersion = "24.05";
      nix.settings.experimental-features = lib.mkForce ["nix-command" "flakes"];

      nix.registry = inputsToRegistry origin.inputs;

      nix.gc = {
        automatic = true;
        frequency = "daily";
        options = "--delete-older-than 30d";
      };

      # nix.registry = {
      #   zig-overlay = {
      #     flake = origin.inputs.zig-overlay;
      #   };
      #   zls = {
      #     flake = origin.inputs.zls;
      #   };
      # };

      copper.features = [
        "link-config"
      ];

      maxdots.features = [
        "chroma-darwin"
        "cli-hm"
        "darwin/sketchybar"
        "development"
        "direnv"
        "neovim"
        # "neovide"
        "productivity"
        "sops"
        "tmux"
      ];

      nixpkgs.config.permittedInsecurePackages = [
        "electron-25.9.0"
        "freeimage-unstable-2021-11-01"
      ];

      home.packages = with pkgs; [
        tiny
      ];

      # programs.ssh.enable = false;
    })
    #
    #
    # # The module below makes sure desktop apps are correctly copied into ~/Applications
    # # Not sure why this is necessary, and not supplied out of the box by home-manager :sigh:
    # # https://github.com/nix-community/home-manager/issues/1341
    # ({
    #   pkgs,
    #   config,
    #   lib,
    #   ...
    # }: {
    #   home.activation = {
    #     copyApplications = let
    #       apps = pkgs.buildEnv {
    #         name = "home-manager-applications";
    #         paths = config.home.packages;
    #         pathsToLink = "/Applications";
    #       };
    #     in
    #       lib.hm.dag.entryAfter ["writeBoundary"] ''
    #         baseDir="$HOME/Applications/Home Manager Apps"
    #         if [ -d "$baseDir" ]; then
    #           rm -rf "$baseDir"
    #         fi
    #         mkdir -p "$baseDir"
    #         for appFile in ${apps}/Applications/*; do
    #           target="$baseDir/$(basename "$appFile")"
    #           $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
    #           $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
    #         done
    #       '';
    #   };
    # })
  ];
  system = "aarch64-darwin";
}
