{
  config,
  origin,
  pkgs,
  ...
}: let
  inherit (origin.config.gleaming) src;
  secretPath = src + "/secrets/users/${config.home.username}";
in {
  imports = [
    origin.inputs.sops-nix.homeManagerModules.sops
  ];

  sops = let
    defaultSops = secretPath + "/default.yaml";
    accountSops = secretPath + "/accounts.yaml";
    vdirSecretDir = "${config.xdg.configHome}/vdirsyncer/secrets";
  in {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = defaultSops;

    secrets.github_token = {};
    secrets.github_packages_token = {
      path = "${config.xdg.configHome}/.github_packages_token";
    };

    #secrets.ics-personal-url.sopsFile = accountSops;
    #secrets.ics-volvocars-url.sopsFile = accountSops;
    secrets.caldav-ourstudio-clientid = {
      sopsFile = accountSops;
      path = vdirSecretDir + "/caldav-ourstudio-clientid";
    };
    secrets.caldav-ourstudio-clientsecret = {
      sopsFile = accountSops;
      path = vdirSecretDir + "/caldav-ourstudio-clientsecret";
    };
    #secrets.caldav-ourstudio-url.sopsFile = accountSops;
  };

  home.packages = with pkgs; [
    sops
  ];
}
