{...}: {
  nixpkgs.overlays = [
    (final: prev: {
      azuredatastudio = prev.azuredatastudio.overrideAttrs (old: rec {
        extraPackages = [
          final.libsecret
        ];
        rpath = prev.lib.concatStringsSep ":" [
          old.rpath
          (final.lib.makeLibraryPath [final.libsecret])
        ];

        fixupPhase = ''
            fix_sqltoolsservice()
            {
              mv ${old.sqltoolsservicePath}/$1 ${old.sqltoolsservicePath}/$1_old
              patchelf \
                --set-interpreter "${prev.stdenv.cc.bintools.dynamicLinker}" \
                ${old.sqltoolsservicePath}/$1_old

              makeWrapper \
                ${old.sqltoolsservicePath}/$1_old \
                ${old.sqltoolsservicePath}/$1 \
                --set LD_LIBRARY_PATH ${old.sqltoolsserviceRpath}
            }

            fix_sqltoolsservice MicrosoftSqlToolsServiceLayer
            fix_sqltoolsservice MicrosoftSqlToolsCredentials
            fix_sqltoolsservice SqlToolsResourceProviderService

          patchelf \
            --set-interpreter "${prev.stdenv.cc.bintools.dynamicLinker}" \
            ${old.targetPath}/${old.edition}

          mkdir -p $out/bin
          makeWrapper \
            ${old.targetPath}/bin/${old.edition} \
            $out/bin/azuredatastudio \
            --set LD_LIBRARY_PATH ${rpath}
        '';
      });
    })
  ];
}
