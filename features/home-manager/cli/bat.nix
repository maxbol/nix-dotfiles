{ pkgs, ... }: {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batgrep
    ];
  };

  programs.zsh.shellAliases = {
    cat = "${pkgs.bat}/bin/bat";
  };
}