{ ... }: let 
  user = "max";
in {
  services = {
    syncthing = {
      inherit user;
      enable = true;
      dataDir = "/home/${user}/Documents";
      configDir = "/home/${user}/Documents/.config/syncthing";
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
      settings = {
        devices = {
          "whatbox" = { id = "VHJAHGCVJN2ZWOCHWU4YJDKP7Z3AYZOZTQF7R4EAR57OKI2LA7LDFOAK"; };
        };
        folders = {
          "Documents" = {         # Name of folder in Syncthing, also the folder ID
            path = "/home/${user}/Documents";    # Which folder to add to Syncthing
            devices = [ "whatbox" ];      # Which devices to share the folder with
          };
        };
      };
    };
  };
}
