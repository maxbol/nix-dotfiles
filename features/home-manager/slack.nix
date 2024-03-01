{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (slack.overrideAttrs
      (default: {
        installPhase = default.installPhase + ''
          rm $out/bin/slack

          makeWrapper $out/lib/slack/slack $out/bin/slack \
          --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
          --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
          --add-flags "--disable-gpu --disable-gpu-compositing --disable-software-rasterizer"
        '';
      })
    )
  ]; 
}
