{ pkgs
, config
, ...
}:
# All gaming-related stuff
{
  home.packages = with pkgs; [
    lutris
    wineWowPackages.staging
    # Minecraft
    prismlauncher
  ];
}

