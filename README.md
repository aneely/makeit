# makeit

Your Mac gets restarted. Apps are gone, windows are gone, your display resolution is
wrong. `makeit morning` puts everything back.

```bash
makeit morning       # restore full environment from bare restart
makeit studio        # home studio setup
makeit list          # show available profiles
makeit clear         # run clear.lua — quit managed apps
makeit ./draft.lua   # run any .lua file directly
```

Profiles are plain Lua files. You define what a working environment looks like — which
apps to launch, how windows are arranged, which tmux sessions to spin up — and makeit
runs it with one command.

## Requirements

- macOS
- [Hammerspoon](https://www.hammerspoon.org) installed and running as a login item
- `hs` CLI installed: open Hammerspoon → Console, run `hs.ipc.cliInstall()` once to install the binary
- `require("hs.ipc")` in your `~/.hammerspoon/init.lua` so the IPC module loads on every restart
- `lua` for running profile unit tests (`brew install lua`)

## Install

```bash
git clone https://github.com/aneely/makeit ~/dev/makeit
make -C ~/dev/makeit install
```

This copies `makeit` to `~/.local/bin`. Make sure that's on your `$PATH`.

## Setup

Profiles live in a config repo — a plain git repo you own and control. Pick a location:

```bash
make -C ~/dev/makeit init CONFIG_DIR=~/dev/my-profiles
cd ~/dev/my-profiles && git init && git add . && git commit -m "initial profiles"
```

Then tell makeit where to find it — add to your `.zshrc`:

```bash
export MAKEIT_CONFIG=~/dev/my-profiles
```

Your config repo travels with you. Clone it on a new machine, set the env var, and
you're back to your full environment in one command.

If you use [direnv](https://direnv.net), a `~/dev/.envrc` is a nice alternative to the
`.zshrc` export — all child directories inherit it without touching your global shell config.

**Just want to try it first?** `make -C ~/dev/makeit init` scaffolds into
`~/.config/makeit/` with no configuration needed.

## Writing profiles

Profiles are plain Lua with access to the full [Hammerspoon API](https://www.hammerspoon.org/docs/).
`scaffold/work.lua` in this repo is a working starting point. `PLAN.md` covers the
architecture and design decisions in depth.

To test a profile without running it live, use the `hs` mock pattern in
`scaffold/work_test.lua` — run with `lua tests/work_test.lua` from your config repo.

## Cold start: Ghostty window

Ghostty launches as a login item but does not open a window — it appears in the Dock
silently. Setting `initial-window = true` in your Ghostty config is necessary but not
sufficient on its own; the login-item launch context suppresses window creation regardless.

The reliable fix is a Hammerspoon timer in `~/.hammerspoon/init.lua` that activates
Ghostty a few seconds after startup:

```lua
hs.timer.doAfter(5, function()
  hs.application.launchOrFocus("Ghostty")
end)
```

When Hammerspoon activates Ghostty with no window open, `initial-window = true` fires and
a window appears. The 5-second delay is a reasonable starting point — tune it up if
Ghostty isn't ready, down if the wait feels long.

Your Ghostty config lives at `~/Library/Application Support/com.mitchellh.ghostty/config`.
Add:

```
initial-window = true
```
