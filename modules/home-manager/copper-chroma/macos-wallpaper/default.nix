{
  pkgs,
  lib,
  ...
}: let
  # m = lib.getExe pkgs.m-cli;
  # sqlite3 = lib.getExe pkgs.sqlite;
  # wallpaper = pkgs.writeScript "wallpaper" ''
  #   ${sqlite3} ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '$1'" && killall Dock
  # '';
  wallpaper = pkgs.writeScript "wallpaper" ''
    [[ -z "$1" ]] && echo "Usage: wallpaper <path-to-image>" && exit 1
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$1\""
  '';
in {
  options = {
    copper.chroma.macoswallpaper.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = ''
        Whether to enable macoswallpaper setting as part of Chroma.
      '';
    };
  };

  config = {
    copper.chroma.programs.macoswallpaper = {
      themeOptions = {
        wallpaper = lib.mkOption {
          type = lib.types.string;
          example = "/path/to/image";
          description = ''
            The path to the wallpaper image.
          '';
        };
      };

      themeConfig = {config, ...}: {
        file."macos-wallpaper-script" = {
          required = true;
          source = lib.mkDefault (pkgs.writeScript "macos-wallpaper-script" ''${wallpaper} ${config.wallpaper}'');
        };
      };

      reloadCommand = "~/.config/chroma/active/macoswallpaper/macos-wallpaper-script";
    };
  };
}
