{...}: {
  nixpkgs.overlays = [
    (final: prev: {
      _1password-gui = prev._1password-gui.overrideAttrs (old: let
        # stable x86_64-linux: sha256-1EfP8z+vH0yRklkcxCOPYExu13iFcs6jOdvWBzl64BA=
        # stable aarch64-linux: sha256-E4MfpHVIn5Vu/TcDgwkoHdSnKthaAMFJZArnmSH5cxA=
        # stable x86_64-mac: sha256-+cXirJyDnxfE5FN8HEIrEyyoGvVrJ+0ykBHON9oHAek=
        # stable aarch64-mac: sha256-zKAgAKYIgy5gZbe2IpskV8DG8AKtamYqq8cF/mTpRss=
        #
        version = "8.10.28";

        sources = {
          stable = {
            x86_64-linux = {
              url = "https://downloads.1password.com/linux/tar/beta/x86_64/1password-${version}.x64.tar.gz";
              hash = "sha256-1EfP8z+vH0yRklkcxCOPYExu13iFcs6jOdvWBzl64BA=";
            };
            aarch64-linux = {
              url = "https://downloads.1password.com/linux/tar/beta/aarch64/1password-${version}.arm64.tar.gz";
              hash = "sha256-E4MfpHVIn5Vu/TcDgwkoHdSnKthaAMFJZArnmSH5cxA=";
            };
            x86_64-darwin = {
              url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
              hash = "sha256-+cXirJyDnxfE5FN8HEIrEyyoGvVrJ+0ykBHON9oHAek=";
            };
            aarch64-darwin = {
              url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
              hash = "sha256-zKAgAKYIgy5gZbe2IpskV8DG8AKtamYqq8cF/mTpRss=";
            };
          };
        };

        src = final.fetchurl {
          inherit (sources.stable.${final.stdenv.system} or (throw "unsupported system ${final.stdenv.hostPlatform.system}")) url hash;
        };
      in rec {
        # inherit version src;
        # beta x86_64-linux: sha256-Tpdr+f3xxmzFkbQn2DwRVjH0MUSTU6aa6bI8K1APtjM=
        # beta aarch64-linux: sha256-pX+S0UB/K+LBLr6UqSDUma/OWfCtxwidIHau3C/QA2E=
        # beta x86_64-mac: sha256-eUEIbj+AXdQq7QsN4T7C9Fn0uu1EfB87ajG6nKGBsmo=
        # beta aarch64-mac: sha256-WDzccenZAc9/qHj64Jipg7rpD3ZFuAP++hQX5XJznQg=

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
            --prefix LD_LIBRARY_PATH : ${prev.lib.makeLibraryPath [prev.udev]} \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
        '';
      });
    })
  ];
}
