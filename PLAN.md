# makeit - Project Plan

## Decision Points

### [x] Tool Name
**Decision:** `makeit` — "makeit work", "makeit dev", "makeit personal", etc.
No PATH conflicts. No conflicting brew package.

### [x] Project Location
**Decision:** `~/dev/makeit/`

### [x] Config Isolation (Multi-Machine Portability)
**Decision:** Profiles are plain Lua files in user-managed config repos.
- `$XDG_CONFIG_HOME/makeit/sources` (defaulting to `~/.config/makeit/sources`) is a plain text file listing profile source directories, one per line
- The engine reads this file at startup and searches sources top to bottom; first match wins
- `makeit init` creates or appends to the sources file when scaffolding a new config repo
- Multiple sources allow public, private, and machine-specific profiles to coexist
- Config repos are version-controlled independently of the engine
- Compatible with chezmoi or any dotfiles approach without depending on one

### [x] Profile Switching Behavior
**Decision:** Execute-only. `makeit work` runs `work.lua` — no teardown, no state tracking.
`makeit clear` runs `clear.lua` from the config repo if present (user-authored).

### [x] Subcommands
- `makeit <profile>` — run `<profile>.lua` from the config repo
- `makeit <file.lua>` — run any `.lua` file directly by path (relative or absolute)
- `makeit list` — list available profiles (`.lua` files in config dir)
- `makeit clear` — run `clear.lua` from config repo if present
- No `makeit status` — no state to report

### [x] Profile Capabilities
**Decision:** Profiles use raw Hammerspoon API calls directly. No `lib/` helpers in v1 — add only when a real repeated pattern emerges from use.

Core capabilities (not "later" — these are the point):
- Display management: force native resolution after input switching
- Window layout: position and size windows on specific screens
- App launching with dependency ordering (VPN before network resources)
- tmux session creation for terminal workspace layout
- Finder windows: positioned, sized, with tabs
- Browser windows with specific URLs
- Network share mounting

---

## Origin

The root problem: an ultrawide monitor (5120x1440) loses its native resolution when switching inputs between machines. macOS downgrades to ~3440x1080. The only known fix is a full restart. Restarting destroys a carefully arranged working environment.

makeit was born as a recovery tool — a way to restore app and folder state after a forced restart. The broader vision followed naturally: if you can restore one environment reliably, you can define multiple environments and switch between them intentionally. Budget mode. Studio mode. Deep work mode. The restart recovery use case and the context switching use case are the same tool.

The minimal bootstrap model: terminal emulator opens via login item. Everything else is driven by a single command from the terminal.

---

## What We're Building

A **terminal-first** macOS environment recovery and context switching tool.

```bash
makeit morning           # Full environment restore from bare restart
makeit studio            # Sweep and load home studio setup
makeit budget            # Finance apps, browser tabs, email
makeit list              # Show available profiles
makeit clear             # Run clear.lua — quit managed apps, reset state
makeit ./draft.lua       # Run any .lua file directly — no config repo needed
```

The north star: restart the machine, open the terminal (login item), run one command, and be back to a fully arranged working environment — correct display resolution, apps launched, windows positioned, tmux sessions ready, VPN up, NAS mounted.

---

## Key Philosophy

- **Terminal-first**: one command from the terminal puts the machine in any desired state
- **Profiles are just Lua**: no config format to parse, no DSL to learn — full Hammerspoon API available
- **Recovery first, switching second**: the primary use case is restoring a known good state after disruption
- **Engine and config are separate repos**: engine is identical across machines; profiles are machine-specific
- **No symlinks in the install script**: `make install` copies the binary — how you manage your config dir is your business
- **Version controllable**: both engine and config live in git

---

## Why Hammerspoon (and not bash + osascript)

The core use cases push past what bash + `open` + osascript can do cleanly:

| Capability | bash + osascript | Hammerspoon |
|---|---|---|
| Launch apps | fine | fine |
| Open folders, URLs, shares | fine | fine |
| **Force display resolution** | painful / fragile | `hs.screen:setMode()` |
| **Position and size windows** | very painful | `hs.window`, `hs.layout` |
| **React to display change events** | not possible | `hs.screen.watcher` |
| Conditional logic in profiles | gets ugly | clean Lua |
| Debug errors | cryptic | stack traces |

The display management and window layout requirements — the actual origin of this project — are what earn the Hammerspoon dependency.

Note on the dependency: Hammerspoon must be running as a background daemon. It is configured as a login item after initial setup, so on a fresh restart it will be available by the time you run `makeit morning` from your terminal.

---

## The Motivating Profile

A concrete rendering of the morning restart-recovery scenario:

```lua
-- morning.lua

-- 1. VPN first — all network activity gates on this
hs.application.launchOrFocus("Tailscale")
hs.timer.waitUntil(
  function() return hs.application.find("Tailscale") ~= nil end,
  function()

    -- 2. Fix display resolution
    local screen = hs.screen.primaryScreen()
    screen:setMode(5120, 1440, 2)  -- exact args TBD during build

    -- 3. Mount NAS and open as positioned Finder window
    hs.osascript.applescript('mount volume "smb://nas/share"')
    -- open Finder window, position left side, specific width (TBD: hs.window placement)

    -- 4. Launch persistent apps
    hs.application.launchOrFocus("HomeRow")
    hs.application.launchOrFocus("Rectangle")
    hs.application.launchOrFocus("Messages")

    -- 5. Browser with morning URLs
    hs.application.launchOrFocus("Google Chrome")
    -- open specific URLs via hs.urlevent.openURL() — TBD

    -- 6. tmux session for coding environment
    hs.execute("tmux new-session -d -s morning -c ~/dev")
    hs.execute("tmux new-window -t morning -c ~/dev -n coding")
    hs.execute("tmux new-window -t morning -c ~ -n monitor")
    hs.execute("tmux send-keys -t morning:monitor 'btop' Enter")
    hs.application.launchOrFocus("Ghostty")

  end
)
```

Some specifics (exact screen mode args, Finder window positioning, browser URL opening) are TBD and will be worked out during the build phase. The structure is right.

---

## Capability Layers

| Layer | Handles | How |
|---|---|---|
| Hammerspoon APIs | app launch, window geometry, display modes, event watchers | `hs.*` |
| osascript (via Hammerspoon) | Finder operations, browser windows, network mounts | `hs.osascript.applescript()` |
| tmux | terminal session layout, persistent coding environments | `hs.execute("tmux ...")` |
| Shell (hs.execute) | simple utilities, anything not in Hammerspoon | `hs.execute()` |

**Note:** `hs.execute` runs via `/bin/sh` with a minimal PATH. Use full binary paths
(e.g. `/usr/local/bin/mytool`) rather than bare command names to avoid silent failures.

---

## Profile Patterns

### Ordered execution with gating
When one step must complete before others proceed (e.g. VPN before network resources):
```lua
hs.application.launchOrFocus("Tailscale")
hs.timer.waitUntil(
  function() return hs.application.find("Tailscale") ~= nil end,
  function() -- network-dependent steps here end
)
```

### Window positioning
```lua
local win = hs.application.find("Finder"):mainWindow()
local screen = hs.screen.primaryScreen()
local frame = screen:frame()
win:setFrame({ x = frame.x, y = frame.y, w = frame.w * 0.3, h = frame.h })
```

### tmux sessions
```lua
hs.execute("tmux new-session -d -s " .. name .. " -c " .. dir)
hs.execute("tmux new-window -t " .. name .. " -c " .. other_dir .. " -n coding")
```

### Network shares
Mount after VPN is up; place at end of a section so other things start while auth dialog appears if needed:
```lua
hs.osascript.applescript('mount volume "smb://nas/share"')
```

---

## How Hammerspoon Fits

- **Hammerspoon.app** = Background daemon, runs as login item
- **hs CLI tool** = Executes Lua against the running daemon
- **Your profiles** = Lua files run via `hs -c "dofile('/path/to/profile.lua')"`

After initial setup you never interact with Hammerspoon's GUI.

### Known awkwardness and future path

Requiring a GUI app as a runtime dependency is architecturally inelegant. The `hs` binary installed by `hs.ipc.cliInstall()` is already essentially a standalone Lua+macOS runtime — it just happens to be distributed inside the Hammerspoon app bundle rather than as a standalone CLI.

Hammerspoon was itself forked from **Mjolnir**, an earlier project that took a more modular, CLI-first approach to the same Lua-to-macOS bridge. The instinct to want a `brew install hs` without a GUI app has precedent.

If the Hammerspoon team (or a fork) ever ships a standalone CLI formula, the migration for makeit users is trivial: swap one install command, drop the GUI setup steps. Profile code doesn't change — it's the same `hs` APIs either way.

**Disposition:** note it, watch for it, don't wait on it.

---

## Engine Structure

```
~/dev/makeit/
├── bin/
│   └── makeit              # Shell script: maps makeit <name> to dofile()
├── scaffold/               # Templates copied by make init
│   ├── work.lua            # Sample profile
│   ├── work_test.lua       # Sample Lua test with hs mock
│   └── config.Makefile     # Makefile dropped into new config repo
├── tests/
│   ├── bin/
│   │   └── hs              # Mock hs binary for BATS tests
│   ├── test_helper/        # Vendored bats-assert, bats-support, bats-file
│   ├── test_makeit.bats    # BATS tests for the shell wrapper
│   ├── test_make_init.bats # BATS tests for make init
│   ├── smoke.bats          # Smoke tests: dependency checks and daemon boundary
│   └── smoke_probe.lua     # Lua fixture used by the daemon boundary smoke test
├── plans/                  # Kanban story files (todo/, in-progress/, completed/)
├── session-notes/          # Freeform session notes by date
├── Makefile
├── README.md
└── .gitignore
```

## User Config Repo

Profile source directories are listed in `~/.config/makeit/sources`, one per line.
The engine searches top to bottom; first match wins.

```
# ~/.config/makeit/sources
~/scratchpad
~/dev/my-profiles
~/dev/work-profiles
```

`makeit init` and `makeit adopt` manage this file — users don't need to edit it by hand.

```
~/dev/my-profiles/
├── morning.lua
├── studio.lua
├── budget.lua
├── clear.lua               # Optional — used by makeit clear
├── tests/
│   ├── morning_test.lua
│   └── ...
└── Makefile                # test target: lua tests/
```

---

## One-Time Setup

### Hammerspoon (required once per machine)
1. `brew install --cask hammerspoon`
2. `open -a Hammerspoon` — grant Accessibility permissions when prompted
3. Open Hammerspoon console (menu bar icon → Console), run `hs.ipc.cliInstall()`
4. Create `~/.hammerspoon/init.lua` containing: `hs.ipc.cliInstall()`

### Install dependencies
5. `brew install lua` — required for profile unit tests (`lua tests/work_test.lua`)

### Install makeit
6. `git clone https://github.com/you/makeit ~/dev/makeit`
7. `make -C ~/dev/makeit install` — installs `makeit` to `~/.local/bin`, warns if `hs` missing

### Quick start (no config repo needed)
8. Write any `.lua` file and run it: `makeit ./my-script.lua`

### Full config repo setup (when ready)
9. `make -C ~/dev/makeit init` — scaffolds config dir with a sample profile and passing test
   - Custom location: `make -C ~/dev/makeit init CONFIG_DIR=~/dev/my-profiles`
   - Then add `export MAKEIT_CONFIG=~/dev/my-profiles` to `.zshrc`
10. `cd <config-dir> && git init && git add . && git commit -m "initial profiles"`
11. `makeit work`

---

## How makeit Works

The `bin/makeit` shell script:
1. Handles built-in commands (`list`, `clear`) first
2. If the argument ends in `.lua` or looks like a path (contains `/`, starts with `.` or `~`): treat as a file path and run it directly
3. Otherwise: treat as a profile name and resolve via the search path:
   - Read `$XDG_CONFIG_HOME/makeit/sources` (default `~/.config/makeit/sources`) to get an ordered list of source directories
   - Search top to bottom; first directory containing `<name>.lua` wins
4. `makeit list` collects all `.lua` files from all sources, annotates each with its source path, and marks duplicates in losing sources as `[shadowed]`
5. Before running any profile, checks that `hs` is on PATH and Hammerspoon is running — exits with a clear message if either is missing
6. Runs it: `hs -c "dofile([==[...]==])"`  — Lua long-string delimiters avoid quoting issues with paths

This means a config repo is not required to get a first win — write any `.lua` file, run it with `makeit file.lua`.

---

## Makefile

```makefile
PREFIX             ?= ~/.local
DEFAULT_CONFIG_DIR ?= $(HOME)/.config/makeit
CONFIG_DIR         ?= $(DEFAULT_CONFIG_DIR)

install:
	install -d $(PREFIX)/bin
	install -m 755 bin/makeit $(PREFIX)/bin/makeit
	@command -v hs >/dev/null 2>&1 || \
		echo "  hs not found. Open Hammerspoon -> Console and run: hs.ipc.cliInstall()"

uninstall:
	rm -f $(PREFIX)/bin/makeit

test:
	bats tests/*.bats

# Scaffold a new config repo at CONFIG_DIR (or custom: make init CONFIG_DIR=~/dev/my-profiles)
init:
	mkdir -p $(CONFIG_DIR)/tests
	@if [ ! -f $(CONFIG_DIR)/work.lua ]; then \
		cp scaffold/work.lua $(CONFIG_DIR)/work.lua; \
		echo "  Created $(CONFIG_DIR)/work.lua"; \
	fi
	@if [ ! -f $(CONFIG_DIR)/tests/work_test.lua ]; then \
		cp scaffold/work_test.lua $(CONFIG_DIR)/tests/work_test.lua; \
		echo "  Created $(CONFIG_DIR)/tests/work_test.lua"; \
	fi
	@if [ ! -f $(CONFIG_DIR)/Makefile ]; then \
		cp scaffold/config.Makefile $(CONFIG_DIR)/Makefile; \
		echo "  Created $(CONFIG_DIR)/Makefile"; \
	fi
	@if [ "$(CONFIG_DIR)" != "$(DEFAULT_CONFIG_DIR)" ]; then \
		echo "  Add to your .zshrc: export MAKEIT_CONFIG=$(CONFIG_DIR)"; \
	fi
	@echo "  Done. To version-control your profiles:"
	@echo "    cd $(CONFIG_DIR) && git init && git add . && git commit -m \"initial profiles\""
	@echo "  Then: makeit work"

.PHONY: install uninstall test init
```

---

## Testing Approach

- **Shell wrapper** (`make test`): BATS tests covering profile dispatch, `list`, `clear`, missing profile error, missing/unconfigured config dir, and the engine contract (that `hs` receives `MAKEIT_CONFIG` as an injected Lua global)
- **Smoke tests** (`make smoke`): require a live Hammerspoon instance; verify dependencies are installed (`hs`, Hammerspoon, `lua`) and that `MAKEIT_CONFIG` survives the trip into the daemon. Intended for post-install verification on a new machine, not run by `make test`
- **Profiles** (`<config-repo>/tests/`): Lua tests using a lightweight `hs` mock — stub the `hs` table, `dofile()` the profile, assert on observed calls. Run with plain `lua`. `make init` scaffolds a passing example test out of the box.

```lua
-- tests/work_test.lua
local launched = {}
hs = {
  application = { launchOrFocus = function(n) table.insert(launched, n) end },
  urlevent    = { openURL = function(url) end },
  osascript   = { applescript = function(s) end },
  execute     = function(cmd) end,
  timer       = { waitUntil = function(f, cb) cb() end }  -- immediate in tests
}

dofile("work.lua")

assert(#launched > 0, "expected at least one app to launch")
print("OK")
```

Manual testing is still the final word — a passing test means the profile runs without errors and calls the expected functions, not that macOS responded correctly.

---

## Glide Path to Homebrew

- **Phase 1** (now): Repo with Makefile, `make install` to `~/.local/bin`
- **Phase 2**: Tagged GitHub releases
- **Phase 3**: Homebrew tap — installs `bin/makeit` to `$(brew --prefix)/bin/`

Note: Hammerspoon is a cask and cannot be declared as a formula dependency. Document as a manual prerequisite.

Config (`$MAKEIT_CONFIG`) is always separate from the install location — works correctly whether installed via `make install` or Homebrew.
