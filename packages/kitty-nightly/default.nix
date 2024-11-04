{
  darwin,
  harfbuzz,
  stdenv,
  ...
}:
darwin.apple_sdk_11_0.callPackage ./kitty {
  harfbuzz = harfbuzz.override {withCoreText = stdenv.hostPlatform.isDarwin;};
  inherit (darwin.apple_sdk_11_0) Libsystem;
  inherit
    (darwin.apple_sdk_11_0.frameworks)
    Cocoa
    Kernel
    UniformTypeIdentifiers
    UserNotifications
    ;
}
