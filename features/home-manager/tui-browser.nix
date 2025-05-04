{
  config,
  origin,
  pkgs,
  lib,
  ...
}: let
  unstable-pkgs = origin.inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
  extensions = config.nur.repos.rycee.firefox-addons;

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

  firefox = pkgs.runCommand "firefox-with-customjs" {} ''
    RESOURCES="$out/Applications/Firefox.app/Contents/Resources"

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

  autoReloadCssUCJS =
    pkgs.writeText "autoReloadCss.uc.js"
    /*
    js
    */
    ''
      (function () {
        const { classes: Cc, interfaces: Ci } = Components;

        const dirSvc = Cc["@mozilla.org/file/directory_service;1"]
          .getService(Ci.nsIProperties);
        const chromeDir = dirSvc.get("UChrm", Ci.nsIFile);

        const ioService = Cc["@mozilla.org/network/io-service;1"]
          .getService(Ci.nsIIOService);

        const sss = Cc["@mozilla.org/content/style-sheet-service;1"]
          .getService(Ci.nsIStyleSheetService);

        // Define stylesheet groups
        const variableProviders = [
          "colors.css",
        ];

        const variableConsumers = [
          "userChrome.css",
          "userContent.css",
        ];

        // Merge and tag all stylesheets
        const fileData = [...variableProviders, ...variableConsumers].map(name => {
          const file = chromeDir.clone();
          file.append(name);
          return {
            name,
            file,
            uri: ioService.newFileURI(file),
            type: name === "userContent.css" ? sss.USER_SHEET : sss.AGENT_SHEET,
            lastModified: 0,
            isVariableProvider: variableProviders.includes(name),
          };
        });

        function reloadStylesheets() {
          // Unregister all in reverse order (consumers first)
          for (const data of [...fileData].reverse()) {
            if (data.file.exists() && sss.sheetRegistered(data.uri, data.type)) {
              sss.unregisterSheet(data.uri, data.type);
              console.log(`[userChrome.js] Unregistered ''${data.name}`);
            }
          }

          console.log("Flushing cache");
          Cc["@mozilla.org/observer-service;1"]
            .getService(Ci.nsIObserverService)
            .notifyObservers(null, "chrome-flush-caches");

          // Re-register in correct order: providers first
          for (const data of fileData) {
            if (data.file.exists()) {
              sss.loadAndRegisterSheet(data.uri, data.type);
              console.log(`[userChrome.js] Reloaded ''${data.name}`);
            }
          }
        }

        function checkForChanges() {
          for (const data of fileData) {
            if (!data.file.exists()) continue;
            const mod = data.file.lastModifiedTime;
            if (mod !== data.lastModified) {
              console.log(`[userChrome.js] Found change in ''${data.name}`);
              data.lastModified = mod;
              reloadStylesheets();
              break; // only trigger once per poll
            }
          }
        }

        // Initial load
        // reloadStylesheets();
        for (const data of fileData) {
          if (data.file.exists()) {
            data.lastModified = data.file.lastModifiedTime;
          }
        }

        // Poll every 1 seconds
        setInterval(checkForChanges, 1000);
      })();
    '';

  userChromeJS = pkgs.writeText "userChrome.js" ''
    userChrome.import("/userChrome/autoReloadCss.uc.js", "UChrm");
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
    profile = "default";
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
      CHROME_DIR="${config.home.homeDirectory}/${configDir}/default/chrome"
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
      CACHE_DIR="${config.home.homeDirectory}/Library/Caches/Firefox/Profiles/default/startupCache"
      rm -Rf "$CACHE_DIR"
    '';
}
