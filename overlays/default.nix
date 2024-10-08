{...}: {
  nixpkgs.overlays = [
    (final: prev: {
      _1password-gui-beta = prev._1password-gui-beta.overrideAttrs (old: rec {
        # beta x86_64-linux: sha256-Tpdr+f3xxmzFkbQn2DwRVjH0MUSTU6aa6bI8K1APtjM=
        # beta aarch64-linux: sha256-pX+S0UB/K+LBLr6UqSDUma/OWfCtxwidIHau3C/QA2E=
        # beta x86_64-mac: sha256-eUEIbj+AXdQq7QsN4T7C9Fn0uu1EfB87ajG6nKGBsmo=
        # beta aarch64-mac: sha256-WDzccenZAc9/qHj64Jipg7rpD3ZFuAP++hQX5XJznQg=

        version = "8.10.34-23.BETA";

        sources = {
          beta = {
            x86_64-linux = {
              url = "https://downloads.1password.com/linux/tar/beta/x86_64/1password-${version}.x64.tar.gz";
              hash = "sha256-Tpdr+f3xxmzFkbQn2DwRVjH0MUSTU6aa6bI8K1APtjM=";
            };
            aarch64-linux = {
              url = "https://downloads.1password.com/linux/tar/beta/aarch64/1password-${version}.arm64.tar.gz";
              hash = "sha256-pX+S0UB/K+LBLr6UqSDUma/OWfCtxwidIHau3C/QA2E=";
            };
            x86_64-darwin = {
              url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
              hash = "sha256-eUEIbj+AXdQq7QsN4T7C9Fn0uu1EfB87ajG6nKGBsmo=";
            };
            aarch64-darwin = {
              url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
              hash = "sha256-WDzccenZAc9/qHj64Jipg7rpD3ZFuAP++hQX5XJznQg=";
            };
          };
        };

        src = final.fetchurl {
          inherit (sources.beta.${final.stdenv.system} or (throw "unsupported system ${final.stdenv.hostPlatform.system}")) url hash;
        };

        preFixup = ''
          # makeWrapper defaults to makeBinaryWrapper due to wrapGAppsHook
          # but we need a shell wrapper specifically for `NIXOS_OZONE_WL`.
          # Electron is trying to open udev via dlopen()
          # and for some reason that doesn't seem to be impacted from the rpath.
          # Adding udev to LD_LIBRARY_PATH fixes that.
          # Make xdg-open overrideable at runtime.
          makeShellWrapper $out/share/1password/1password $out/bin/1password \
            "''${gappsWrapperArgs[@]}" \
            --suffix PATH : ${prev.lib.makeBinPath [prev.xdg-utils]} \
            --prefix LD_LIBRARY_PATH : ${prev.lib.makeLibraryPath [prev.udev]}
            # Currently half broken on wayland (e.g. no copy functionality)
            # See: https://github.com/NixOS/nixpkgs/pull/232718#issuecomment-1582123406
            # Remove this comment when upstream fixes:
            # https://1password.community/discussion/comment/624011/#Comment_624011
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
        '';
      });
      postman = prev.postman.overrideAttrs (old: rec {
        version = "10.23.5";
        src = final.fetchurl {
          url = "https://dl.pstmn.io/download/version/${version}/linux64";
          sha256 = "sha256-svk60K4pZh0qRdx9+5OUTu0xgGXMhqvQTGTcmqBOMq8=";

          name = "${old.pname}-${version}.tar.gz";
        };
      });
    })
  ];
}
