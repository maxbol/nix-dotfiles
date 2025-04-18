{
  config,
  origin,
  pkgs,
  lib,
  ...
}: let
  unstable-pkgs = origin.inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
  extensions = config.nur.repos.rycee.firefox-addons;

  firefox =
    if pkgs.stdenv.hostPlatform.isDarwin == true
    then unstable-pkgs.firefox-unwrapped
    else pkgs.firefox;

  firefoxMacOSCmd = pkgs.writeShellScriptBin "firefox" ''
    cd ${firefox}/Applications/Firefox.app/Contents/MacOS
    ./firefox $@
  '';
in {
  imports = [
    origin.inputs.nur.modules.homeManager.default
    origin.inputs.textfox.homeManagerModules.default
  ];

  programs.firefox = {
    enable = true;
    package = firefox;
    profiles = {
      default = {
        isDefault = true;
        settings = {
          "svg.context-properties.content.enabled" = true;
          "shyfox.enable.ext.mono.toolbar.icons" = true;
          "shyfox.enable.ext.mono.context.icons" = true;
          "shyfox.enable.context.menu.icons" = true;
        };
        extensions = with extensions; [
          vimium
          ublock-origin
          brotab
          darkreader
        ];
      };
    };
  };

  textfox = {
    enable = true;
    profile = "default";
    # copyOnActivation = true;
    config = {
      displayNavButtons = true;
      displaySidebarTools = true;
      displayTitles = false;
      font = {
        family = "Iosevka";
        size = "18px";
      };
    };
  };

  home.packages = with pkgs; [
    brotab
    firefox
    fira-code
    (lib.mkIf
      (pkgs.stdenv.hostPlatform.isDarwin == true)
      firefoxMacOSCmd)
  ];

  home.sessionVariables.BROWSER = "firefox";
}
