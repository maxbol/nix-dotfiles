{
  config,
  origin,
  pkgs,
  lib,
  ...
}: let
  unstable-pkgs = origin.inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
  extensions = config.nur.repos.rycee.firefox-addons;

  profileName = "default";

  firefox-unmodified =
    if pkgs.stdenv.hostPlatform.isDarwin == true
    then unstable-pkgs.firefox-unwrapped
    else pkgs.firefox;

  customJsForFx = pkgs.fetchFromGitHub {
    owner = "Aris-t2";
    repo = "CustomJSForFx";
    rev = "4218e39d802d5852563d4da6e4c88ae91645b5cb";
    hash = "sha256-2Y9wso3nz3kdbfzl8Fk/qhL/v0epitrHUhHCjCKYsQ4=";
  };

  resourcesPath =
    if pkgs.stdenv.hostPlatform.isDarwin == true
    then "/Applications/Firefox.app/Contents/Resources"
    else "/usr/lib/firefox";

  startupCachePath =
    if pkgs.stdenv.hostPlatform.isDarwin == true
    then "${config.home.homeDirectory}/Library/Caches/Firefox/Profiles/${profileName}/startupCache"
    else "${config.home.homeDirectory}/.cache/mozilla/firefox/${profileName}/startupCache";

  firefox = pkgs.runCommand "firefox-with-customjs" {} ''
    RESOURCES="$out${resourcesPath}"

    cp -R ${firefox-unmodified} $out
    chmod u+w $RESOURCES
    cp ${customJsForFx}/script_loader/firefox/config.js "$RESOURCES/config.js"
    cp -R ${customJsForFx}/script_loader/firefox/defaults "$RESOURCES/defaults"
    chmod u-w $RESOURCES
  '';

  firefoxMacOSCmd = pkgs.writeShellScriptBin "firefox" ''
    cd ${firefox}/Applications/Firefox.app/Contents/MacOS
    ./firefox $@
  '';

  configDir =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "Library/Application\ Support/Firefox/Profiles/"
    else ".mozilla/firefox/";

  autoReloadCssUCJS = ./autoReloadCss.uc.js;
  userChromeJS = ./userChrome.js;
in {
  imports = [
    origin.inputs.nur.modules.homeManager.default
    origin.inputs.textfox.homeManagerModules.default
  ];

  programs.firefox = {
    enable = true;
    package = firefox;
    profiles = {
      ${profileName} = {
        isDefault = true;
        settings = {
          "svg.context-properties.content.enabled" = true;
          "shyfox.enable.ext.mono.toolbar.icons" = true;
          "shyfox.enable.ext.mono.context.icons" = true;
          "shyfox.enable.context.menu.icons" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "general.config.filename" = "mozilla.cfg";
          "general.config.obscure_value" = 0;
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
    profile = profileName;
    flattenCss = true;
    copyOnActivation = true;
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
    # fira-code
    iosevka
    (lib.mkIf
      (pkgs.stdenv.hostPlatform.isDarwin == true)
      firefoxMacOSCmd)
  ];

  home.sessionVariables.BROWSER = "firefox";

  home.activation.installFirefoxJSLoader =
    lib.hm.dag.entryAfter ["linkGeneration"]
    /*
    bash
    */
    ''
      CHROME_DIR="${config.home.homeDirectory}/${configDir}/${profileName}/chrome"
      cp -R ${customJsForFx}/script_loader/profile/userChrome "$CHROME_DIR"
      chmod -R u+w "$CHROME_DIR/userChrome"
      cp ${autoReloadCssUCJS} "$CHROME_DIR/userChrome/autoReloadCss.uc.js"
      chmod u+w "$CHROME_DIR/userChrome/autoReloadCss.uc.js"
      cp ${userChromeJS} "$CHROME_DIR/userChrome.js"
      chmod u+w "$CHROME_DIR/userChrome.js"
    '';

  home.activation.clearFirefoxStartupCache =
    lib.hm.dag.entryAfter ["linkGeneration"]
    /*
    bash
    */
    ''
      rm -Rf "${startupCachePath}"
    '';
}
