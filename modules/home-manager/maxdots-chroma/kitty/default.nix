{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.maxdots.chroma;

  optionalPackage = opt:
    optional (opt != null && opt.package != null) opt.package;

  inherit (import ../../../../lib/types.nix {inherit lib;}) colorType;
in {
  options = {
    maxdots.chroma.kitty.enable = mkOption {
      type = types.bool;
      default = config.programs.kitty.enable;
      example = false;
      description = ''
        Whether to enable Kitty theming as part of Chroma.
      '';
    };
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.enable && cfg.kitty.enable) || config.programs.kitty.enable;
        message = "Chroma Kitty theming requires Kitty to be enabled.";
      }
    ];
    # TODO: set the font to the monospace font?

    maxdots.chroma.programs.kitty = let
      pkill =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "/usr/bin/pkill"
        else "${pkgs.procps}/bin/pkill";
    in {
      themeOptions = {
        font = mkOption {
          type = types.nullOr hm.types.fontType;
          default = {
            name = "Iosevka";
            size = 18;
            package = pkgs.iosevka;
          };
          description = ''
            The font to use in kitty.
          '';
        };
        autoGenerate = mkOption {
          type = types.submodule {
            options = {
              enable = mkOption {
                type = types.bool;
                default = false;
              };

              colorOverrides = mkOption {
                type = types.attrsOf colorType;
                default = {};
                description = ''
                  Color overrides to apply to the palette-generated theme.
                '';
              };
            };
          };
          default = {};
        };
      };

      themeConfig = {
        config,
        opts,
        ...
      }: {
        imports = [
          (
            mkIf config.autoGenerate.enable (
              let
                themeSource = opts.palette.generateDynamic {
                  template = ./theme.conf.dyn;
                  paletteOverrides = config.autoGenerate.colorOverrides;
                };
              in {
                file."theme.conf".source = themeSource;
              }
            )
          )
        ];

        file."fonts.conf" = {
          text =
            if config.font != null
            then ''
              font_family ${config.font.name}
              font_size ${toString config.font.size}
            ''
            else "";
        };
      };

      reloadCommand = mkForce "${pkill} -USR1 -u $USER kitty || true";
    };

    programs.kitty.extraConfig = mkIf (cfg.enable && cfg.kitty.enable) ''
      include ${config.maxdots.chroma.themeDirectory}/active/kitty/theme.conf
      include ${config.maxdots.chroma.themeDirectory}/active/kitty/fonts.conf
    '';
    # programs.kitty.settings.include = mkIf (cfg.enable && cfg.kitty.enable) "${config.maxdots.chroma.themeDirectory}/active/kitty/theme.conf";
  };

  imports = [
    (mkIf (cfg.enable && cfg.kitty.enable) {
      home.packages = concatLists (mapAttrsToList (name: opts: with opts.kitty; concatMap optionalPackage [font]) cfg.themes);
    })
  ];
}
