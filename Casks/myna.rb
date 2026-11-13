cask "myna" do
  version "0.1.170078"
  sha256 arm:   "9bbe914dd1d5b92a0ada16d27b549ae2729c9eb4b159a5f9dafa35be0e5afcde",
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
    Signed + notarized (Developer ID Application: Kasun Paranagamage Don, F5Q59PPGF5).
    First launch opens without a Gatekeeper prompt. Future updates install in-place via
    the built-in updater; if you installed an earlier ad-hoc build, run
    `brew upgrade --cask myna` once to move onto the signed stream.
  EOS
end
