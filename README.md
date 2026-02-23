# makeit

A terminal-first macOS environment recovery and context switching tool.

```bash
makeit morning       # restore full environment from bare restart
makeit studio        # home studio setup
makeit list          # show available profiles
makeit clear         # run clear.lua — quit managed apps
makeit ./draft.lua   # run any .lua file directly
```

## Requirements

- macOS
- [Hammerspoon](https://www.hammerspoon.org) installed and running
- `hs` CLI installed (run `hs.ipc.cliInstall()` in Hammerspoon console once)
- `lua` — for running profile unit tests (`brew install lua`)

## Install

```bash
git clone https://github.com/aneely/makeit ~/dev/makeit
make -C ~/dev/makeit install
```

## Setup

The recommended approach is a version-controlled config repo at a location of your choice:

```bash
make -C ~/dev/makeit init CONFIG_DIR=~/dev/my-profiles
cd ~/dev/my-profiles && git init && git add . && git commit -m "initial profiles"
```

Then add to your `.zshrc`:

```bash
export MAKEIT_CONFIG=~/dev/my-profiles
```

This keeps your profiles in git, portable across machines, and separate from the engine.

**Quick start (no env var):** `make -C ~/dev/makeit init` scaffolds into `~/.config/makeit/` — no configuration needed, but not version-controlled by default.

## Writing profiles

Profiles are plain Lua files with access to the full [Hammerspoon API](https://www.hammerspoon.org/docs/).

See `scaffold/work.lua` for a starting point and `PLAN.md` for architecture details.
