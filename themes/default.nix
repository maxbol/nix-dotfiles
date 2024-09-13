{
  pkgs,
  extraArgs,
  ...
}: {
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
        accent1 = palette.accents.sky;
        accent2 = palette.accents.mauve;
        accent3 = palette.accents.pink;
        orange = palette.accents.peach;
      };

      neovimColorscheme = "catppuccin-latte";
      neovimBackground = "light";
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
        accent1 = palette.accents.sky;
        accent2 = palette.accents.mauve;
        accent3 = palette.accents.pink;
        orange = palette.accents.peach;
      };

      neovimColorscheme = "catppuccin-macchiato";
      neovimBackground = "dark";
    });

  Gruvbox-Dark = pkgs.callPackage ./gruvbox.nix (extraArgs
    // {
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

      neovimColorscheme = "gruvbox-material";
      neovimBackground = "dark";
      neovimHlGroupsFg = {
        HLChunk1 = "#8ec07c";
        HLLineNum1 = "#8ec07c";
      };
    });

  Gruvbox-Light = pkgs.callPackage ./gruvbox.nix (extraArgs
    // {
      luminance = "light";

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

      neovimColorscheme = "gruvbox-material";
      neovimBackground = "light";
      neovimHlGroupsFg = {
        HLChunk1 = "#427b58";
        HLLineNum1 = "#427b58";
      };
    });

  Rose-Pine = pkgs.callPackage ./rosepine.nix (extraArgs
    // {
      variant = "pine";
      neovimColorscheme = "rose-pine-main";
      neovimBackground = "dark";
      neovimHlGroupsFg = {
        HLChunk1 = "#c4a7e7";
        HLLineNum1 = "#c4a7e7";
      };
    });

  Rose-Pine-Moon = pkgs.callPackage ./rosepine.nix (extraArgs
    // {
      variant = "moon";
      neovimColorscheme = "rose-pine-moon";
      neovimBackground = "dark";
      neovimHlGroupsFg = {
        HLChunk1 = "#c4a7e7";
        HLLineNum1 = "#c4a7e7";
      };
    });

  Rose-Pine-Dawn = pkgs.callPackage ./rosepine.nix (extraArgs
    // {
      variant = "dawn";
      neovimColorscheme = "rose-pine-dawn";
      neovimBackground = "light";
      neovimHlGroupsFg = {
        HLChunk1 = "#907aa9";
        HLLineNum1 = "#907aa9";
      };
    });

  Tsoding-Mode = pkgs.callPackage ./tsoding-mode.nix (extraArgs
    // {
      neovimColorscheme = "gruber-darker";
      neovimBackground = "dark";
      neovimHlGroupsFg = {
        HLChunk1 = "#ffdd33";
        HLLineNum1 = "#ffdd33";
      };
    });
}
