{
  pkgs,
  lib,
  ...
}: let
  killall = "${pkgs.killall}/bin/killall";
  wallpaper = pkgs.writeScript "wallpaper" ''
    [[ -z "$1" ]] && echo "Usage: wallpaper <path-to-image>" && exit 1
    new_wallpaper_path="$1"

    /usr/libexec/PlistBuddy -c "set AllSpacesAndDisplays:Desktop:Content:Choices:0:Files:0:relative file:///$new_wallpaper_path" ~/Library/Application\ Support/com.apple.wallpaper/Store/Index.plist

    if [[ "$?" -ne 0 ]]; then
      echo "Warning: Wallpaper settings has been set to not show in all spaces, falling back to osascript solution that will only set wallpaper on current space"
      osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$1\""
      exit 0
    fi

    ${killall} WallpaperAgent
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
          type = lib.types.str;
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
