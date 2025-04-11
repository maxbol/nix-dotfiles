{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.maxdots.chroma;
in {
  options = {
    maxdots.chroma.dynawall = {
      enable = lib.mkEnableOption "dynawall";
    };
  };

  config = {
    maxdots.chroma.programs.dynawall = {
      themeOptions = {
        shader = lib.mkOption {
          type = lib.types.enum ["default" "helloworld" "voronoi2" "monterrey2"];
          default = "voronoi2";
          description = ''
            The shader to use
          '';
        };
        colorOverrides = lib.mkOption {
          type = lib.types.attrs;
          default = {};
          description = ''
            Color overrides to apply to the palette-generated theme.
          '';
        };
      };

      themeConfig = {
        config,
        opts,
        ...
      }: {
        file."dynawall.conf" = {
          text = let
            conf = {
              shader = config.shader;
              palette =
                {
                  accents = map (v: "#" + v) (lib.attrValues opts.palette.accents);
                  bg = "#" + opts.palette.semantic.background;
                }
                // config.colorOverrides;
            };
          in
            builtins.toJSON conf;
        };
      };

      reloadCommand = let
        pkill =
          if pkgs.stdenv.hostPlatform.isDarwin
          then "/usr/bin/pkill"
          else "${pkgs.procps}/bin/pkill";
      in "${pkill} -USR1 -u $USER dynawall";
    };
  };

  imports = [
    (lib.mkIf cfg.enable {
      xdg.configFile."dynawall.conf".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${cfg.themeDirectory}/active/dynawall/dynawall.conf");
    })
  ];
}
