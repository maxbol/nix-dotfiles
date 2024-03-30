{pkgs, ...}:
pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = "theme-base";
  version = "unstable-2024-03-29";
  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "tmux";
    rev = "c0861b786123d5b375074e3649a2a8575694504e";
    sha256 = "sha256-pddbfaqkqXSQd0V7bEHEp4CT7ZgqKW6R9aNlT4d3tAw=";
  };
  preInstall = ''
    mkdir -p themes/

    mv catppuccin.tmux theme_base.tmux
    mv *.tmuxtheme themes/

    sed -i -e 's|@catppuccin|@theme_base|g' theme_base.tmux

    find . -type f -exec sed -i -e 's|thm_gray|thm_surface|g' {} \;
    find . -type f -exec sed -i -e 's|thm_black4|thm_overlay|g' {} \;
    find . -type f -exec sed -i -e 's|thm_cyan|thm_accent1|g' {} \;
    find . -type f -exec sed -i -e 's|thm_magenta|thm_accent2|g' {} \;
    find . -type f -exec sed -i -e 's|thm_pink|thm_accent3|g' {} \;

    sed -i -e 's|thm_gray|thm_surface|g' theme_base.tmux **/*.sh

    sed -i -e 's|theme="$(get_tmux_option "@theme_base_flavour" "mocha")"|theme="$(get_tmux_option "@theme_base_theme" "''${PLUGIN_DIR}/themes/catppuccin-mocha.tmuxtheme")"|g' theme_base.tmux

    sed -i -e 's|''${PLUGIN_DIR}/catppuccin-''${theme}.tmuxtheme|''${theme}|g' theme_base.tmux
  '';
}
