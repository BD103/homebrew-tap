cask "finamp@beta" do
  version "0.9.25-beta"
  sha256 "f43f5edd62c7ea6d272ffc301795fa5c4512aada3d46e348b58cb27198f375b1"

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

  depends_on macos: :catalina

  app "Finamp.app"

  zap trash: [
    "~/Library/Application Scripts/com.unicornsonlsd.finamp-ios",
    "~/Library/Containers/com.unicornsonlsd.finamp-ios",
  ]
end
