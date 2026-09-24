cask "myna" do
  version "0.1.3"
  sha256 arm:   "a527257b070264d8d231412d9e482def42bab0d13cc537e6c1a553dc2fdb8aed",
         intel: "0000000000000000000000000000000000000000000000000000000000000000"

  # The download API serves a versioned 302 to a short-lived presigned artifact URL; Homebrew follows it.
  # Two builds, one per Mac architecture.
  # NOTE: this is the raw API-gateway download endpoint. A production cask should front it with a branded,
  # stable URL (a CloudFront /downloads/* behaviour on ktk.tools.ktek.cloud → this origin).
  arch arm: "darwin-arm64", intel: "darwin-x64"
  url "https://91iar0i6uj.execute-api.us-east-1.amazonaws.com/downloads/myna-#{arch}/#{version}",
      verified: "91iar0i6uj.execute-api.us-east-1.amazonaws.com/"
  name "myna"
  desc "AI coding editor — a Code-OSS fork with codemyna built in"
  homepage "https://ktk.tools.ktek.cloud/"

  # The app also self-updates in place; Homebrew just installs and (via `brew upgrade`) replaces it.
  auto_updates true
  depends_on macos: :big_sur

  app "myna.app"

  # The `myna` CLI (myna . == code .). Symlinked so it lands on PATH like the app's own shell command.
  binary "#{appdir}/myna.app/Contents/Resources/app/bin/myna"

  zap trash: [
    "~/.myna",
    "~/Library/Application Support/myna",
    "~/Library/Preferences/cloud.codemyna.myna.plist",
    "~/Library/Saved Application State/cloud.codemyna.myna.savedState",
  ]

  caveats <<~EOS
    Until myna ships notarized builds, macOS Gatekeeper may block the first launch.
    If it does, open it once with:  xattr -dr com.apple.quarantine "#{appdir}/myna.app"
    then launch normally. (This is standard for un-notarized apps; it is not a workaround
    for any security control on a machine you do not own.)
  EOS
end
