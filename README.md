# homebrew-myna

Homebrew tap for **myna** — an AI coding editor: a Code-OSS fork with the codemyna
assistant built in (baked-in default chat agent, no separate extension to install).

Currently published: **macOS Apple Silicon (arm64)** only. Intel (x64) is on the way.

## Install

```sh
brew tap KasunDon/myna
brew install --cask myna
```

If Homebrew refuses to load the cask ("untrusted tap"), accept the prompt or run:

```sh
brew trust --cask KasunDon/myna/myna
```

### First launch (unsigned build)

myna isn't code-signed/notarized yet, so macOS Gatekeeper may block the first launch.
Clear the quarantine flag once, then open normally:

```sh
xattr -dr com.apple.quarantine /Applications/myna.app
open -a myna
```

### The `myna` command

The cask puts a `myna` launcher on your `PATH`, so from any terminal:

```sh
myna .                 # open the current folder (equivalent to `code .`)
myna path/to/project   # open a folder
myna --version         # print version / commit / arch
```

## Update

```sh
brew update
brew upgrade --cask myna
```

(The app can also update itself in place once signed builds ship.)

## Uninstall

```sh
brew uninstall --cask myna      # remove the app
brew untap KasunDon/myna        # remove the tap (optional)
```

To also delete myna's local data (settings, cache, saved state):

```sh
brew uninstall --zap --cask myna
```

## What gets installed

| Item | Location |
|------|----------|
| Application | `/Applications/myna.app` |
| `myna` CLI | `/opt/homebrew/bin/myna` → the app's launcher |
| Download cache | `~/Library/Caches/Homebrew/downloads/` |
| App data (removed on `--zap`) | `~/.myna`, `~/Library/Application Support/myna` |

## Notes

- The download is ~430 MB (the editor bundles its own Electron runtime).
- Verified by SHA-256 in the cask; a mismatch aborts the install.
- Prompts and code are sent, E2E-encrypted, to the endpoint the build is configured
  with — the same backend as the codemyna VS Code extension.
