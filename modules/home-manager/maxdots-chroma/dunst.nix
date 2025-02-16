{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options = {
    maxdots.chroma.dunst.enable = mkOption {
      type = types.bool;
      default = config.services.dunst.enable;
      example = false;
      description = ''
        Whether to enable Dunst theming as part of Chroma.
      '';
    };
  };

  config = {
    maxdots.chroma.programs.dunst = {
      themeConfig = {opts, ...}: {
        file."dunstrc".text = ''
          [global]
              ### Icons ###

              # Recursive icon lookup. You can set a single theme, instead of having to
              # define all lookup paths.
              enable_recursive_icon_lookup = true

              # Set icon theme (only used for recursive icon lookup)
              # You can also set multiple icon themes, with the leftmost one being used first.
              icon_theme = ${opts.desktop.iconTheme.name}
        '';
      };
    };
  };

  imports = [
    (mkIf (config.maxdots.chroma.enable && config.maxdots.chroma.dunst.enable) {
      assertions = [
        {
          assertion = config.maxdots.chroma.desktop.enable;
          message = "Chroma's desktop module is required for the Dunst module.";
        }
      ];
      maxdots.chroma.desktop.enable = true;

      xdg.configFile."dunst/dunstrc.d/50-chroma".source = config.lib.file.mkOutOfStoreSymlink "${config.maxdots.chroma.themeDirectory}/active/dunst/dunstrc";
    })
  ];
}
