{ config, origin, ... }: let inherit (origin.config.gleaming) basepath; secretPath = basepath + "/secrets/users/${config.home.username}" in {
  imports = [
    origin.inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = "/home/${config.home.username}/.config/sops/age/keys.txt";
    secrets = {
      accounts = secretPath + "/accounts.yaml";
    };
  };
}
