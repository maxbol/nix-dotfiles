{
  pkgs,
  makeDesktopItem,
  symlinkJoin,
  ...
}: let
  name = "tableplus";
  version = "0.1.248";
  tableplus = pkgs.stdenv.mkDerivation {
    inherit name;

    src = pkgs.fetchurl {
      url = "https://deb.tableplus.com/debian/22/pool/main/t/${name}/${name}_${version}_amd64.deb";
      sha256 = "sha256-+qVBip0ADyYb2Xnv2ohrn1jPZ1UGJv2chhl3XnoEvEE=";
    };
    sourceRoot = "opt/tableplus";

    unpackPhase = ''
      runHook preUnpack
      dpkg-deb -x $src .
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      ls -la
      mkdir -p "$out/bin"
      cp -R "tableplus" "$out/bin/tableplus"
      cp -R "resource/" "$out"
      chmod -R g-w "$out"
      # # Desktop file
      # mkdir -p "$out/share/applications"
      # cp "$desktopItem}/share/applications/"* "$out/share/applications"
      runHook postInstall
    '';

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      dpkg
      makeWrapper
      wrapGAppsHook
    ];
    buildInputs = with pkgs; [
      stdenv.cc.cc.lib
      libgee
      json-glib
      openldap
      gtksourceview4
      libsecret
      gtksourceview
      krb5Full.dev
    ];
  };

  tableplus-desktop = makeDesktopItem {
    inherit name;
    desktopName = "TablePlus";
    exec = "${tableplus}/bin/tableplus";
    icon = "${tableplus}/resource/image/logo.png";
    categories = ["Development"];
  };
in
  symlinkJoin {
    inherit name;
    paths = [tableplus tableplus-desktop];
  }
