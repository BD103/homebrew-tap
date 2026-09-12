cask "finamp@beta" do
  version "1.0.1-beta"
  sha256 "8d607b57c12726c5bcd6109e0ac02028233bead786a3132137ffc81385eb940a"

  url "https://github.com/finamp-app/finamp/releases/download/#{version}/Finamp-#{version}-macOS.zip"
  name "Finamp"
  desc "Open source Jellyfin music player"
  homepage "https://github.com/finamp-app/finamp"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+-beta)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  depends_on macos: :monterey

  app "Finamp.app"

  zap trash: [
    "~/Library/Application Scripts/com.unicornsonlsd.finamp-ios",
    "~/Library/Containers/com.unicornsonlsd.finamp-ios",
  ]
end
