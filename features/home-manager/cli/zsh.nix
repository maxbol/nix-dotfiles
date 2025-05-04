{
  config,
  lib,
  pkgs,
  maxdots,
  origin,
  ...
}: let
  zig-bleeding-edge = origin.inputs.zig-overlay.packages.${pkgs.system}.master;

  ta = pkgs.writeShellScriptBin "ta" ''
    if [ "$TMUX" = "" ]; then tmux attach; fi
  '';

  cbread = pkgs.writeShellScript "cbread" ''
    if [[ $(uname) = "Darwin" ]]; then
      pbcopy
    else
      wl-copy
    fi
  '';

  cbprint = pkgs.writeShellScript "cbprint" ''
    if [[ $(uname) = "Darwin" ]]; then
      pbpaste
    else
      wl-paste
    fi
  '';

  zsh-vi-clipboard-fix = pkgs.writeShellScriptBin "zsh-vi-clipboard-fix.sh" ''
    my_zvm_vi_yank() {
      zvm_vi_yank
      echo -en "''${CUTBUFFER}" | ${cbread}
    }

    my_zvm_vi_delete() {
      zvm_vi_delete
      echo -en "''${CUTBUFFER}" | ${cbread}
    }

    my_zvm_vi_change() {
      zvm_vi_change
      echo -en "''${CUTBUFFER}" | ${cbread}
    }

    my_zvm_vi_change_eol() {
      zvm_vi_change_eol
      echo -en "''${CUTBUFFER}" | ${cbread}
    }

    my_zvm_vi_put_after() {
      CUTBUFFER=$(${cbprint})
      zvm_vi_put_after
      zvm_highlight clear # zvm_vi_put_after introduces weird highlighting for me
    }

    my_zvm_vi_put_before() {
      CUTBUFFER=$(${cbprint})
      zvm_vi_put_before
      zvm_highlight clear # zvm_vi_put_before introduces weird highlighting for me
    }

    zvm_after_lazy_keybindings() {
      zvm_define_widget my_zvm_vi_yank
      zvm_define_widget my_zvm_vi_delete
      zvm_define_widget my_zvm_vi_change
      zvm_define_widget my_zvm_vi_change_eol
      zvm_define_widget my_zvm_vi_put_after
      zvm_define_widget my_zvm_vi_put_before

      zvm_bindkey visual 'y' my_zvm_vi_yank
      zvm_bindkey visual 'd' my_zvm_vi_delete
      zvm_bindkey visual 'x' my_zvm_vi_delete
      zvm_bindkey vicmd  'C' my_zvm_vi_change_eol
      zvm_bindkey visual 'c' my_zvm_vi_change
      zvm_bindkey vicmd  'p' my_zvm_vi_put_after
      zvm_bindkey vicmd  'P' my_zvm_vi_put_before
    }
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
    autosuggestion.enable = true;
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
    # historySubstringSearch = {
    #   enable = true;
    #   searchUpKey = ["^[[A"];
    #   searchDownKey = ["^[[B"];
    # };

    profileExtra = ''
      if command -v systemctl &> /dev/null; then
        systemctl --user import-environment PATH
      fi
    '';

    initExtra = ''
      export EDITOR=nvim

      # case insensitive tab completion in a menu
      zstyle ':completion:*' completer _complete _ignored _approximate
      zstyle ':completion:*' list-colors
      zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' menu select
      zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
      zstyle ':completion:*' verbose true
      _comp_options+=(globdots)

      token_file="${config.xdg.configHome}/.github_packages_token"
      if [ -f "$token_file" ]; then
        export NPM_TOKEN=$(cat "$token_file");
        export GOTOKEN=$(cat "$token_file");
        export NIX_CONFIG="access-tokens = github.com=$(cat "$token_file")"
      fi

      ZVM_INIT_MODE=sourcing

      source <(${lib.getExe maxdots.packages.clockify-cli} completion zsh)
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      source ${zsh-vi-clipboard-fix}/bin/zsh-vi-clipboard-fix.sh
      source ${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.zsh

      # bindkey "^[[A" history-beginning-search-backward
      # bindkey "^[[B" history-beginning-search-forward

      export LLDB_VSCODE_PATH="${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter"
      export PATH="$PATH:$HOME/bin:$HOME/go/bin:/opt/homebrew/bin:$HOME/.local/bin:$LLDB_VSCODE_PATH"

      export LLDB_USE_NATIVE_PDB_READER="yes"
      if [[ $(uname -s) == "Darwin" ]]; then
        export LLDB_DEBUGSERVER_PATH="/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/Resources/debugserver"
        # export LLDB_DEBUGSERVER_PATH="${pkgs.lldb_18}/bin/darwin-debug"
      fi

      export ZIG_BLEEDING_EDGE_BIN="${zig-bleeding-edge}/bin/zig"

      # export MANPAGER="less -R --use-color -Dd+r -Du+b"
      export MANPAGER='nvim +Man!'

      setopt PUSHDSILENT

      alias time="/usr/bin/time"
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
