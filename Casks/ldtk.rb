cask "ldtk" do
  version "1.5.3"
  sha256 "d8f8ab8f7e2001a64d7db04eac8d68ec305fd21d3404a2d40d9e0377aa5dac62"

  url "https://ldtk.io/files/builds/#{version}/mac-distribution.zip"
  name "LDtk"
  desc "Open-source 2D level editor with a strong focus on user-friendliness"
  homepage "https://ldtk.io/"

  livecheck do
    url "https://github.com/deepnight/ldtk/releases/latest/download/latest.yml"
    strategy :electron_builder
  end

  depends_on macos: :catalina

  app "LDtk.app"

  preflight do
    # Remove quarantine attribute on app, since it isn't notarized and won't open by default. This
    # isn't secure, but you accept the risk when installing LDtk.
    system_command "/usr/bin/xattr", args: ["-d", "com.apple.quarantine", "#{staged_path}/LDtk.app"]
  end

  zap trash: [
    "~/Library/Application Support/LDtk",
    "~/Library/Logs/LDtk",
    "~/Library/Preferences/com.deepnight.ldtk.plist",
  ]

  caveats "LDtk is not notarized by Apple, automatically deleting com.apple.quarantine xattr."
end
