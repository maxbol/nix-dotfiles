{
  pkgs,
  extraArgs,
  ...
}: {
  Ayu-Dark = pkgs.callPackage ./ayu.nix (extraArgs
    // {
      copper = extraArgs.inputs.copper.packages;
      variant = "dark";

      tmuxOverrides = palette: {
        status_window_active_fg = palette.semantic.surface;
        status_modules_inner_bg = palette.semantic.overlay;
        status_modules_inner_fg = palette.semantic.text2;
        status_modules_outer_bg = palette.accents.lightblue;
        status_modules_outer_fg = palette.semantic.surface;
      };

      neovimOverrides = palette: {
        colorscheme = "ayu-dark";
        background = "dark";
        hlGroupsFg = {
          HLChunk1 = "#" + palette.semantic.accent1;
          HLLineNum1 = "#" + palette.semantic.accent1;
          LineNr = "#" + palette.semantic.text2;
          IncSearch = "#" + palette.semantic.background;
          Function = "#" + palette.semantic.text;
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

      tmuxOverrides = palette: {
        status_window_active_fg = palette.semantic.surface;
        status_modules_inner_bg = palette.semantic.overlay;
        status_modules_inner_fg = palette.semantic.text2;
        status_modules_outer_bg = palette.accents.lightblue;
        status_modules_outer_fg = palette.semantic.surface;
      };

      neovimOverrides = palette: {
        colorscheme = "ayu-mirage";
        background = "dark";
        hlGroupsFg = {
          HLChunk1 = "#" + palette.semantic.accent1;
          HLLineNum1 = "#" + palette.semantic.accent1;
          Function = "#" + palette.accents.mauve;
        };
        hlGroupsBg = {
          Visual = "#" + palette.semantic.text2;
        };
      };
    });

  Catppuccin-Latte = pkgs.callPackage ./catppuccin.nix (extraArgs
    // {
      copper = extraArgs.inputs.copper.packages;

      variant = "latte";
      accent = "rosewater";

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

      tmuxOverrides = palette: {
        status_window_active_fg = palette.semantic.surface;
      };

      neovimOverrides = palette: {
        colorscheme = "catppuccin-latte";
        background = "light";
        hlGroupsFg = {
          HLChunk1 = "#" + palette.semantic.accent2;
          HLLineNum1 = "#" + palette.semantic.accent2;
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

      tmuxOverrides = palette: {
        status_window_active_fg = palette.semantic.surface;
        status_window_active_bg = palette.accents.rosewater;
        status_modules_inner_bg = palette.semantic.surface;
        status_modules_inner_fg = palette.semantic.text;
        status_modules_outer_bg = palette.semantic.overlay;
        status_modules_outer_fg = palette.semantic.text;
      };

      sketchybarOverrides = palette: {
        focused_space = palette.accents.rosewater;
      };

      neovimOverrides = palette: {
        colorscheme = "catppuccin-macchiato";
        background = "dark";
        hlGroupsFg = {
          HLChunk1 = "#" + palette.semantic.accent2;
          HLLineNum1 = "#" + palette.semantic.accent2;
        };
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
        };
        hlGroupsBg = {
          # CursorLine = "#" + palette.semantic.overlay;
          # Visual = "#427b58";
          TelescopeSelection = "#427b58";
        };
      };

      tmuxOverrides = palette: {
        status_window_active_fg = palette.semantic.surface;
        status_window_active_bg = palette.accents.aqua;
        status_modules_inner_bg = palette.accents.orange;
        status_modules_outer_bg = palette.semantic.overlay;
        status_modules_outer_fg = palette.semantic.text1;
      };

      sketchybarOverrides = palette: {
        focused_space = palette.accents.aqua;
      };
    });

  # Gruvbox-Light = pkgs.callPackage ./gruvbox.nix (extraArgs
  # // {
  #   luminance = "light";
  #
  #   hyprlandOverrides = palette: {
  #     active1 = "90ceaa"; # "#90ceaa";
  #     active2 = "ecd3a0"; # "#ecd3a0";
  #     inactive1 = "1e8b50"; # "#1e8b50";
  #     inactive2 = "50b050"; # "#50b050";
  #   };
  #
  #   rofiOverrides = palette: {
  #     main-background = palette.semantic.background;
  #     text = palette.semantic.text1;
  #     border = palette.semantic.surface;
  #     highlight = palette.accents.neutralblue;
  #     highlight-text = palette.semantic.text1;
  #   };
  #
  #   waybarOverrides = palette: {
  #     overlay = palette.semantic.background;
  #   };
  #
  #   neovimOverrides = palette: {
  #     colorscheme = "gruvbox-material";
  #     background = "light";
  #     hlGroupsFg = {
  #       HLChunk1 = "#427b58";
  #       HLLineNum1 = "#427b58";
  #     };
  #   };
  # });

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
      tmuxOverrides = palette: {
        status_window_active_fg = palette.semantic.surface;
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
      tmuxOverrides = palette: {
        status_window_active_fg = palette.semantic.surface;
      };
    });

  # Rose-Pine-Dawn = pkgs.callPackage ./rosepine.nix (extraArgs
  #   // {
  #     variant = "dawn";
  #     neovimOverrides = palette: {
  #       colorscheme = "rose-pine-dawn";
  #       background = "light";
  #       hlGroupsFg = {
  #         HLChunk1 = "#907aa9";
  #         HLLineNum1 = "#907aa9";
  #       };
  #     };
  #   });

  Tsoding-Mode = pkgs.callPackage ./tsoding-mode.nix (extraArgs
    // {
      neovimOverrides = palette: {
        colorscheme = "gruber-darker";
        background = "dark";
        hlGroupsFg = {
          HLChunk1 = "#ffdd33";
          HLLineNum1 = "#ffdd33";
          "@property" = "#" + palette.accents.darkbrown;
        };
        hlGroupsBg = {
          FoldColumn = "#181818";
        };
      };

      tmuxOverrides = palette: {
        status_session_fg = palette.semantic.surface;
        status_session_bg = palette.accents.yellow;
        status_window_active_fg = palette.semantic.surface;
        status_window_active_bg = palette.accents.green;
        status_modules_inner_bg = palette.accents.wisteria;
        status_modules_outer_fg = palette.semantic.text1;
        status_modules_outer_bg = palette.semantic.surface;
      };

      sketchybarOverrides = palette: {
        focused_space = palette.accents.green;
      };
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

      tmuxOverrides = palette: {
        status_window_active_fg = palette.semantic.text1;
        status_modules_inner_fg = palette.semantic.surface;
        status_modules_inner_bg = palette.accents.blue;
        status_modules_outer_fg = palette.semantic.text2;
        status_modules_outer_bg = palette.semantic.overlay;
      };

      yaziOverrides = palette: {
        filetype_fallback_dir_fg = palette.accents.blue;
      };
    });

  Bluloco-Light = pkgs.callPackage ./bluloco.nix (extraArgs
    // {
      luminance = "light";
      neovimOverrides = palette: {
        colorscheme = "bluloco-light";
        background = "light";
        hlGroupsFg = {
          HLChunk1 = "#" + palette.semantic.accent1;
          HLLineNum1 = "#" + palette.semantic.accent1;
        };
      };
    });

  # Oh-Lucy = pkgs.callPackage ./ohlucy.nix (extraArgs
  #   // {
  #     neovimOverrides = palette: {
  #       colorscheme = "oh-lucy";
  #       background = "dark";
  #       hlGroupsFg = {
  #         HLChunk1 = "#" + palette.semantic.accent2;
  #         HLLineNum1 = "#" + palette.semantic.accent2;
  #       };
  #     };
  #   });
}
