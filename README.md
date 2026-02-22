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

## Install

```bash
git clone https://github.com/you/makeit ~/dev/makeit
make -C ~/dev/makeit install
```

## Setup

```bash
# Scaffold a config repo at ~/.config/makeit/
make -C ~/dev/makeit init

# Or at a custom location:
make -C ~/dev/makeit init CONFIG_DIR=~/dev/my-profiles
# then add to .zshrc: export MAKEIT_CONFIG=~/dev/my-profiles
```

## Writing profiles

Profiles are plain Lua files with access to the full [Hammerspoon API](https://www.hammerspoon.org/docs/).

See `scaffold/work.lua` for a starting point and `docs/plan.md` for architecture details.
