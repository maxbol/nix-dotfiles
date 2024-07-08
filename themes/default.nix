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
    });

  Rose-Pine = pkgs.callPackage ./rosepine.nix (extraArgs
    // {
      variant = "pine";
    });

  Rose-Pine-Moon = pkgs.callPackage ./rosepine.nix (extraArgs
    // {
      variant = "moon";
    });

  Rose-Pine-Dawn = pkgs.callPackage ./rosepine.nix (extraArgs
    // {
      variant = "dawn";
    });
}
