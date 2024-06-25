{...}: {
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  #environment.etc."wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
  #  bluez_monitor.properties = {
  #    ["bluez5.enable-sbc-xq"] = false,
  #    ["bluez5.enable-msbc"] = true,
  #    ["bluez5.enable-hw-volume"] = true,
  #    ["bluez5.codecs"] = [ "aac" ]
  #  }
  #'';
}
