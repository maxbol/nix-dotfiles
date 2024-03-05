{ pkgs, ... }: {
  home.packages = [ pkgs.gh ];

  programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;

      userName = "Max Bolotin";
      userEmail = "maks.bolotin@gmail.com";

      aliases = {
        adog = "log --all --decorate --oneline --graph";
      };

      extraConfig = {
        push = {
          autoSetupRemote = true;
        };
      };
  };
}
