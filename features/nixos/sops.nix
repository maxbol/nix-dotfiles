{ origin, config, pkgs, ... }: let inherit (origin.config.gleaming) basepath; secretPath = basepath + "/secrets/hosts/${config.networking.hostName}"; in {
  imports = [
    origin.inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = secretPath + "/default.yaml";
  };

  environment.systemPackages = with pkgs; [
    sops
  ];
}
