{
  config,
  lib,
  options,
  ...
}:
with lib; let
  cfg = config.maxdots.chroma;

  optionalPackage = opt:
    optional (opt != null && opt.package != null) opt.package;
in {
  options = {
    maxdots.chroma.desktop.enable = mkEnableOption "Desktop settings for Chromma";
  };

  config = {
    maxdots.chroma.programs.desktop = {
      themeOptions = rec {
        iconTheme = options.gtk.iconTheme;
        cursorTheme = options.gtk.cursorTheme;
        font = mkOption {
          type = types.nullOr hm.types.fontType;
          default = null;
          description = ''
            The font to use in desktop applications.
          '';
        };
        monospaceFont =
          font
          // {
            description = ''
              The font to use in desktop applicaitons where a monospace font is
              required.
            '';
          };

        # TODO: is light/dark preference a setting here?
      };
    };
  };

  imports = [
    (mkIf (cfg.enable && cfg.desktop.enable) {
      home.packages = concatLists (mapAttrsToList (name: opts: with opts.desktop; concatMap optionalPackage [iconTheme cursorTheme font monospaceFont]) cfg.themes);
    })
  ];
}

