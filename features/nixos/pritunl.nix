{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.pritunl-client
  ];

  systemd.services.pritunl-client-daemon = {
    description = "Pritunl Client Daemon";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      PIDFile = "/var/run/pritunl-client.pid";
      ExecStart = "${pkgs.pritunl-client}/bin/pritunl-client-service";
    };
  };
}
