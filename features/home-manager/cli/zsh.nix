{
  config,
  lib,
  pkgs,
  maxdots,
  ...
}: let
  ta = pkgs.writeShellScriptBin "ta" ''
    if [ "$TMUX" = "" ]; then tmux attach; fi
  '';
in {
  home.packages = [
    ta
    pkgs.ripgrep
    pkgs.ripgrep-all
    pkgs.tealdeer
  ];

  programs.eza.enable = true;

  programs.zsh = {
    enable = true;
    # dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      l = "eza --icons";
      ll = "eza --icons -l";
      la = "eza --icons -la";
      tree = "eza --tree";
      vim = "nv";
      vi = "nv";
      zb = "zig build";
      zbr = "zig build run";
    };
    history = {
      # path = "${config.home.homeDirectory}/.zshistory";
      ignoreDups = true;
      ignoreSpace = true;
      save = 10000;
      share = true;
    };
    historySubstringSearch = {
      enable = true;
      searchUpKey = ["^[[A"];
      searchDownKey = ["^[[B"];
    };

    profileExtra = ''
      echo "Importing \$PATH into systemd: $PATH" > /tmp/systemdpathimport-$(date +%s)

      systemctl --user import-environment PATH
    '';

    initExtra = ''
      # case insensitive tab completion in a menu
      zstyle ':completion:*' completer _complete _ignored _approximate
      zstyle ':completion:*' list-colors
      zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' menu select
      zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
      zstyle ':completion:*' verbose true
      _comp_options+=(globdots)

      #if [ "$TMUX" = "" ]; then tmux; fi

      token_file="${config.xdg.configHome}/.github_packages_token"
      if [ -f "$token_file" ]; then export NPM_TOKEN=$(cat "$token_file"); fi

      source <(${lib.getExe maxdots.packages.clockify-cli} completion zsh)
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      bindkey "^[[A" history-beginning-search-backward
      bindkey "^[[B" history-beginning-search-forward

      export PATH="$PATH:$HOME/bin:$HOME/go/bin"

      setopt PUSHDSILENT
    '';

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };

  programs.skim = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden";
    changeDirWidgetOptions = [
      "--preview 'eza --icons --git --color always -T -L 3 {} | head -200'"
      "--exact"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables.DIRENV_LOG_FORMAT = "";
}
