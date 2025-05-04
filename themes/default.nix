{
  pkgs,
  extraArgs,
  ...
}: {
  Ayu-Dark = pkgs.callPackage ./ayu.nix (extraArgs
    // {
      copper = extraArgs.inputs.copper.packages;
      variant = "dark";

      neovimOverrides = palette: {
        colorscheme = "ayu-dark";
        background = "dark";
        hlGroupsFg = {
          HLChunk1 = "#" + palette.semantic.accent2;
          HLLineNum1 = "#" + palette.semantic.accent2;
          LineNr = "#" + palette.semantic.text2;
          IncSearch = "#" + palette.semantic.background;
          Function = "#" + palette.semantic.text;
          BlinkCmpGhostText = "#" + palette.semantic.text1;
        };
        hlGroupsBg = {
          Visual = "#" + palette.semantic.text2;
          IncSearch = "#" + palette.accents.peach;
        };
      };
    });

  Ayu-Mirage = pkgs.callPackage ./ayu.nix (extraArgs
    // {
      copper = extraArgs.inputs.copper.packages;
      variant = "mirage";

      neovimOverrides = palette: {
        colorscheme = "ayu-mirage";
        background = "dark";
        hlGroupsFg = {
          HLChunk1 = "#" + palette.semantic.accent1;
          HLLineNum1 = "#" + palette.semantic.accent1;
          Function = "#" + palette.accents.mauve;
          BlinkCmpGhostText = "#" + palette.semantic.text1;
        };
        hlGroupsBg = {
          Visual = "#" + palette.semantic.text2;
        };
      };
    });

  Blue-Nightmare = pkgs.callPackage ./blue-nightmare.nix (extraArgs
    // {
    });
  Bluloco-Dark = pkgs.callPackage ./bluloco.nix (extraArgs
    // {
      luminance = "dark";
      neovimOverrides = palette: {
        colorscheme = "bluloco-dark";
        background = "dark";
        hlGroupsFg = {
          HLChunk1 = "#" + palette.semantic.accent1;
          HLLineNum1 = "#" + palette.semantic.accent1;
        };
      };

      yaziOverrides = palette: {
        filetype_fallback_dir_fg = palette.accents.blue;
      };
    });

  Catppuccin-Latte = pkgs.callPackage ./catppuccin.nix (extraArgs
    // {
      copper = extraArgs.inputs.copper.packages;

      variant = "latte";
      accent = "rosewater";
      accent2 = "blue";
      accent3 = "mauve";

      hyprlandOverrides = palette: {
        active1 = palette.accents.rosewater;
        active2 = palette.accents.mauve;
        inactive1 = palette.accents.lavender;
        inactive2 = palette.accents.teal;
      };

      rofiOverrides = palette: {
        main-background = palette.all.crust;
        highlight = palette.accents.flamingo;
        highlight-text = palette.all.base;
      };

      waybarOverrides = palette: {
        # active-text = palette.all.crust;
        # hover-highlight = palette.accents.rosewater;
        # hover-text = palette.all.crust;
      };

      neovimOverrides = palette: {
        colorscheme = "catppuccin-latte";
        background = "light";
        hlGroupsFg = {
          HLChunk1 = "#" + palette.semantic.accent2;
          HLLineNum1 = "#" + palette.semantic.accent2;
        };
        hlGroupsBg = {
          CursorLine = "#bcc0cc";
        };
      };
    });

  Catppuccin-Mocha = pkgs.callPackage ./catppuccin.nix (extraArgs
    // {
      copper = extraArgs.inputs.copper.packages;

      variant = "mocha";

      hyprlandOverrides = palette: {
        # This isn't the same as upstream Hyprdots. It actually uses colors from the Frappe palette.
        active1 = palette.accents.mauve;
        active2 = palette.accents.rosewater;
        inactive1 = palette.accents.lavender;
        inactive2 = "6c7086";
      };

      rofiOverrides = palette: {
        main-background = palette.all.crust;
        text = "cdd6f4";
        border = palette.accents.mauve;
        highlight = palette.accents.lavender;
        highlight-text = palette.all.crust;
      };

      waybarOverrides = palette: {
        # main-background = palette.all.crust;
        overlay = palette.all.base;
        # text = "cddt6f4";
        # active-highlight = "a6adc8";
        # active-text = "313244";
        # hover-highlight = palette.accents.pink;
        # hover-text = "313244";
      };

      neovimOverrides = palette: {
        colorscheme = "catppuccin-macchiato";
        background = "dark";
        hlGroupsFg = {
          HLChunk1 = "#" + palette.semantic.accent2;
          HLLineNum1 = "#" + palette.semantic.accent2;
        };
      };

      tmuxOverrides = palette: {
        status_window_inactive_bg = palette.semantic.surface;
        status_modules_outer_bg = palette.semantic.surface;
      };
    });

  Gruvbox-Dark = pkgs.callPackage ./gruvbox.nix (extraArgs
    // {
      luminance = "dark";

      hyprlandOverrides = palette: {
        active1 = "90ceaa"; # "#90ceaa";
        active2 = "ecd3a0"; # "#ecd3a0";
        inactive1 = "1e8b50"; # "#1e8b50";
        inactive2 = "50b050"; # "#50b050";
      };

      rofiOverrides = palette: {
        main-background = palette.semantic.background;
        text = palette.semantic.text1;
        border = palette.semantic.surface;
        highlight = palette.accents.neutralblue;
        highlight-text = palette.semantic.text1;
      };

      waybarOverrides = palette: {
        overlay = palette.semantic.background;
      };

      neovimOverrides = palette: {
        colorscheme = "gruvbox-material";
        background = "dark";
        hlGroupsFg = {
          HLChunk1 = "#8ec07c";
          HLLineNum1 = "#8ec07c";
          BlinkCmpGhostText = "#" + palette.semantic.text1;
        };
        hlGroupsBg = {
          # CursorLine = "#" + palette.semantic.overlay;
          # Visual = "#427b58";
          TelescopeSelection = "#427b58";
        };
      };
    });

  Newpaper-Dark = pkgs.callPackage ./newpaper.nix (extraArgs
    // {
      luminance = "dark";
      neovimOverrides = palette: {
        background = "dark";
      };
    });
  Newpaper-Light = pkgs.callPackage ./newpaper.nix (extraArgs
    // {
      luminance = "light";
    });
  Rose-Pine = pkgs.callPackage ./rosepine.nix (extraArgs
    // {
      variant = "pine";
      neovimOverrides = palette: {
        colorscheme = "rose-pine-main";
        background = "dark";
        hlGroupsFg = {
          HLChunk1 = "#c4a7e7";
          HLLineNum1 = "#c4a7e7";
        };
        hlGroupsBg = {
          CursorLine = "#44415a";
          Cursor = "#6e6a86";
          Folded = "#44415a";
        };
      };
      macoswallpaperOverrides = {
        wallpaper = "$HOME/wallpapers/rosepine-default-7.png";
      };
    });

  Rose-Pine-Eclipse = pkgs.callPackage ./rosepine.nix (extraArgs
    // {
      variant = "eclipse";
      neovimOverrides = palette: {
        colorscheme = "rose-pine-moon";
        background = "dark";
        hlGroupsFg = {
          HLChunk1 = "#c4a7e7";
          HLLineNum1 = "#c4a7e7";
        };
        hlGroupsBg = {
          CursorLine = "#44415a";
          Cursor = "#6e6a86";
          Folded = "#44415a";
        };
      };
    });

  Rose-Pine-Moon = pkgs.callPackage ./rosepine.nix (extraArgs
    // {
      variant = "moon";
      neovimOverrides = palette: {
        colorscheme = "rose-pine-moon";
        background = "dark";
        hlGroupsFg = {
          HLChunk1 = "#c4a7e7";
          HLLineNum1 = "#c4a7e7";
        };
        hlGroupsBg = {
          CursorLine = "#44415a";
          Cursor = "#6e6a86";
          Folded = "#44415a";
        };
      };
    });

  Tsoding-Mode = pkgs.callPackage ./tsoding-mode.nix (extraArgs
    // {
      neovimOverrides = palette: {
        colorscheme = "gruber-darker";
        background = "dark";
        hlGroupsFg = {
          HLChunk1 = "#ffdd33";
          HLLineNum1 = "#ffdd33";
          "@property" = "#" + palette.semantic.text;
          BlinkCmpGhostText = "#949494";
        };
        hlGroupsBg = {
          FoldColumn = "#181818";
        };
      };
      tmuxOverrides = palette: {
        status_session_fg = palette.accents.yellow;
      };
    });

  Oh-Lucy = pkgs.callPackage ./oh-lucy.nix (extraArgs
    // {
      neovimOverrides = palette: {
        colorscheme = "oh-lucy";
      };
    });

  Oh-Lucy-Evening = pkgs.callPackage ./oh-lucy.nix (extraArgs
    // {
      variant = "evening";
      neovimOverrides = palette: {
        colorscheme = "oh-lucy";
      };
    });
}
