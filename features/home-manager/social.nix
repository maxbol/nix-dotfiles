{ pkgs, maxdots, ... }: {
  home.packages = with pkgs; [
    beeper
    maxdots.packages.texts

    # appimageTools.wrapType2 { # or wrapType1
    #   name = "textsdotcom";
    #   src = fetchurl {
    #     url = "https://texts.com/api/install/linux/x64/latest.AppImage";
    #     hash = "8ae643bff448c517b006cad6388e790f22109b743b1de07d9a8bd6100288d779";
    #   };
    #   extraPkgs = pkgs: with pkgs; [ ];
    # }
  ];
}
