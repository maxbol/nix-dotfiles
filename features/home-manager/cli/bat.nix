{pkgs, ...}: {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batgrep
      batman
    ];
  };

  programs.zsh.shellAliases = {
    cat = "${pkgs.bat}/bin/bat --paging=never";
  };
}
