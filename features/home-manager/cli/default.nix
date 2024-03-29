{
  pkgs,
  origin,
  copper,
  maxdots,
  ...
}: {
  imports = [
    ./bat.nix
    ./starship.nix
    ./terminals.nix
    ./zsh.nix
  ];

  # add environment variables
  home.sessionVariables = {
    # set default applications
    EDITOR = "nvim";
    BROWSER = "google-chrome-stable";
    TERMINAL = "kitty";
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND = "fg=green,bold";
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND = "fg=red,bold";
  };

  # programs.ssh.enable = true;

  # nix-index provides a command-not-found implementation as well as
  # nix-locate, which helps with finding the package a binary is contained in.
  programs.nix-index.enable = true;
  # Instead of manually building the database on every host, we grab a
  # pre-built one.
  programs.nix-index.package = copper.inputs.nix-index-database.nix-index-with-db;

  # Install extra packages
  home.packages = with pkgs; [
    alejandra
    bottom
    copper.inputs.nix-index-database.comma-with-db
    entr
    eza
    fd
    fzf
    lsd
    httpie
    jq
    neofetch
    nil
    copper.inputs.nix-search-cli
    nnn
    nurl
    copper.packages.plate
    ranger
    ripgrep
    ripgrep-all
    sd
    tealdeer
    tree
    tokei
    maxdots.packages.clockify-cli
  ];
}
