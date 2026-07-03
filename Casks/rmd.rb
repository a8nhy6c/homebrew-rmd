cask "rmd" do
  version "0.1.0"
  sha256 "d13cd52eb0b49df2ffd6658086b200f1eab17a38d3d8b1858a76c1ee8fddddf8"

  url "https://github.com/a8nhy6c/rmd_app/releases/download/v#{version}/RMD-#{version}.zip"
  name "RMD"
  desc "Remove metadata from image, pdf, video and audio files"
  homepage "https://github.com/a8nhy6c/rmd_app"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "RMD.app"

  postflight do
    # RMD is ad-hoc signed (no paid Apple Developer account), so remove the
    # quarantine flag to let it launch, then register its Finder service.
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/RMD.app"]
    system_command "/System/Library/Frameworks/CoreServices.framework/Frameworks/" \
                   "LaunchServices.framework/Support/lsregister",
                   args: ["-f", "#{appdir}/RMD.app"]
    system_command "/System/Library/CoreServices/pbs", args: ["-flush"]
  end

  uninstall quit:       "com.rmd.app",
            login_item: "RMD"

  uninstall_postflight do
    system_command "/System/Library/Frameworks/CoreServices.framework/Frameworks/" \
                   "LaunchServices.framework/Support/lsregister",
                   args: ["-u", "#{appdir}/RMD.app"]
    system_command "/System/Library/CoreServices/pbs", args: ["-flush"]
  end

  zap trash: [
    "~/Library/Preferences/com.rmd.app.plist",
    "~/Library/Application Support/RMD",
    "~/Library/Caches/com.rmd.app",
    "~/Library/HTTPStorages/com.rmd.app",
    "~/Library/Saved Application State/com.rmd.app.savedState",
  ]
end
