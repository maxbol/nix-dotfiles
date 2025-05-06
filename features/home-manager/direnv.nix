{pkgs, ...}: {
  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;

  xdg.configFile."direnv/direnvrc" = {
    text = ''
      : ''${DIRENV_DIR:=/private/tmp/direnv/$UID}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          local hash path
          echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(${pkgs.coreutils}/bin/sha1sum - <<< "$PWD" | head -c40)"
              path="''${PWD//[^a-zA-Z0-9]/-}"
              echo "''${DIRENV_DIR}/layouts/''${hash}''${path}"
          )}"
      }
    '';
  };

  home.sessionVariables.DIRENV_LOG_FORMAT = "";
}
