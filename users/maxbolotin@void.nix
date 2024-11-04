{
  username = "maxbolotin";
  modules = [
    ({lib, ...}: {
      nix.settings.experimental-features = lib.mkForce ["nix-command" "flakes"];

      copper.features = [
        "link-config"
      ];

      maxdots.features = [
        "chroma-darwin"
        "cli-hm"
        "development"
        "direnv"
        "neovim"
        "neovide"
        "productivity"
        "sops"
        "tmux"
      ];

      nixpkgs.config.permittedInsecurePackages = [
        "electron-25.9.0"
        "freeimage-unstable-2021-11-01"
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
