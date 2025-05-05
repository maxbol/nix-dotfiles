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
      }
    }

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
