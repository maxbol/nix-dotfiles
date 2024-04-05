{
  pkgs,
  origin,
  config,
  maxdots,
  ...
}: let
  spicePkgs = origin.inputs.spicetify-nix.packages.${pkgs.system}.default;
  gruvboxTheme = with pkgs; {
    name = "spotify-theme-gruvbox";
    src = fetchFromGitHub {
      owner = "giovanebribeiro";
      repo = "spotify-gruvbox-theme";
      rev = "fa3bd3aa70b8fa93ecf8ac76c62bff2c0180ba31";
      hash = "sha256-RHSYDA+oZ11eiq6guBoiP/Y1VHFUywuHLnoq2VXAQVY=";
    };
    appendName = false;
    injectCss = true;
    replaceColors = true;
    overwriteAssets = true;
    sidebarConfig = false;
  };
in {
  # import the flake's module for your system
  imports = [origin.inputs.spicetify-nix.homeManagerModule];

  home.packages = with pkgs; [
    # audio control
    pavucontrol
    playerctl
    pulsemixer
    # images
    imv
    # video
    vlc
    # ebooks
    calibre
  ];

  # configure spicetify :)
  programs.spicetify = {
    enable = true;
    # theme = gruvboxTheme;
    theme = spicePkgs.themes.Orchis;
    # theme = spicePkgs.themes.RetroBlur;
    colorScheme = "dark";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
    ];
  };
}
