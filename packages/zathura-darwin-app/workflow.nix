{
  writeText,
  zathuraExe,
}:
writeText "document.wflow" (let
  lightEscapeXml = builtins.replaceStrings ["&" "<" ">"] ["&amp;" "&lt;" "&gt;"];
  source = lightEscapeXml (import ./applescript.nix {inherit zathuraExe;});
in ''<?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
    <key>AMApplicationBuild</key>
    <string>523</string>
    <key>AMApplicationVersion</key>
    <string>2.10</string>
    <key>AMDocumentVersion</key>
    <string>2</string>
    <key>actions</key>
    <array>
      <dict>
        <key>action</key>
        <dict>
          <key>AMAccepts</key>
          <dict>
            <key>Container</key>
            <string>List</string>
            <key>Optional</key>
            <true/>
            <key>Types</key>
            <array>
              <string>com.apple.applescript.object</string>
            </array>
          </dict>
          <key>AMActionVersion</key>
          <string>1.0.2</string>
          <key>AMApplication</key>
          <array>
            <string>Automator</string>
          </array>
          <key>AMParameterProperties</key>
          <dict>
            <key>source</key>
            <dict/>
          </dict>
          <key>AMProvides</key>
          <dict>
            <key>Container</key>
            <string>List</string>
            <key>Types</key>
            <array>
              <string>com.apple.applescript.object</string>
            </array>
          </dict>
          <key>ActionBundlePath</key>
          <string>/System/Library/Automator/Run AppleScript.action</string>
          <key>ActionName</key>
          <string>Kör AppleScript-skript</string>
          <key>ActionParameters</key>
          <dict>
            <key>source</key>
            <string>${source}</string>
          </dict>
          <key>BundleIdentifier</key>
          <string>com.apple.Automator.RunScript</string>
          <key>CFBundleVersion</key>
          <string>1.0.2</string>
          <key>CanShowSelectedItemsWhenRun</key>
          <false/>
          <key>CanShowWhenRun</key>
          <true/>
          <key>Category</key>
          <array>
            <string>AMCategoryUtilities</string>
          </array>
          <key>Class Name</key>
          <string>RunScriptAction</string>
          <key>InputUUID</key>
          <string>CE2A5CBF-D857-426D-80CC-25B89DF9240B</string>
          <key>Keywords</key>
          <array>
            <string>Kör</string>
          </array>
          <key>OutputUUID</key>
          <string>944AC9A1-0E47-4790-80F2-901170EA1BBD</string>
          <key>UUID</key>
          <string>B43B2EB2-99C8-43B5-BBF0-04C4061CEF89</string>
          <key>UnlocalizedApplications</key>
          <array>
            <string>Automator</string>
          </array>
          <key>arguments</key>
          <dict>
            <key>0</key>
            <dict>
              <key>default value</key>
              <string>on run {input, parameters}

    (* Your script goes here *)

    return input
  end run</string>
              <key>name</key>
              <string>source</string>
              <key>required</key>
              <string>0</string>
              <key>type</key>
              <string>0</string>
              <key>uuid</key>
              <string>0</string>
            </dict>
          </dict>
          <key>conversionLabel</key>
          <integer>0</integer>
          <key>isViewVisible</key>
          <integer>1</integer>
          <key>location</key>
          <string>221.500000:315.000000</string>
          <key>nibPath</key>
          <string>/System/Library/Automator/Run AppleScript.action/Contents/Resources/Base.lproj/main.nib</string>
        </dict>
        <key>isViewVisible</key>
        <integer>1</integer>
      </dict>
    </array>
    <key>connectors</key>
    <dict/>
    <key>workflowMetaData</key>
    <dict>
      <key>workflowTypeIdentifier</key>
      <string>com.apple.Automator.application</string>
    </dict>
  </dict>
  </plist>'')
