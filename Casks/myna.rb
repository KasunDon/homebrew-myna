cask "myna" do
  version "0.1.167530"
  sha256 arm:   "d4d3e905580d62337a445e449f29cd383f679e1115d9ef8181c5fcf5af2e5440",
         intel: "0000000000000000000000000000000000000000000000000000000000000000"

  # The download API serves a versioned 302 to a short-lived presigned artifact URL; Homebrew follows it.
  # Two builds, one per Mac architecture.
  # NOTE: this is the raw API-gateway download endpoint. A production cask should front it with a branded,
  # stable URL (a CloudFront /downloads/* behaviour on ktk.tools.ktek.cloud → this origin).
  arch arm: "darwin-arm64", intel: "darwin-x64"
  url "https://91iar0i6uj.execute-api.us-east-1.amazonaws.com/downloads/myna-#{arch}/#{version}"
  name "myna"
  desc "AI coding editor — a Code-OSS fork with codemyna built in"
  homepage "https://ktk.tools.ktek.cloud/"

  # No `auto_updates true` yet: builds are ad-hoc signed, and Squirrel.Mac refuses to apply an update to an
  # app without a Developer ID signature, so Homebrew is the only update path. With `auto_updates true` a
  # plain `brew upgrade` skips this cask (it needs --greedy), which would leave installs on an old build.
  # Restore it once signed builds ship (docs/myna-signing.md in ktk-ai).
  depends_on macos: :big_sur
  # Only the arm64 build is published; the intel sha256 above is a placeholder and its download is a 404.
  # Refusing on Intel up front beats a checksum failure halfway through `brew install`.
  depends_on arch: :arm64

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
