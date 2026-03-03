# Daemon Config Injection Fix

## Problem

`makeit morning` failed immediately with:

```
cannot open /Users/.../.config/makeit/lib/finder.lua: No such file or directory
```

`morning.lua` used `os.getenv("MAKEIT_CONFIG")` to locate its lib files. That env var
is visible in the shell but not inside the Hammerspoon daemon — `hs -c "..."` sends Lua
to the running Hammerspoon.app process, which has its own environment and doesn't inherit
shell exports. The fallback path was used, and `lib/` didn't exist there.

## Solution

The engine already knows the resolved config dir. Inject it as a Lua global before
running the profile, so profiles can reference it without relying on env inheritance.

Engine change in `run_profile` (`bin/makeit`):
```bash
hs -c "MAKEIT_CONFIG=[=[$dir]=]; dofile([=[$path]=])"
```

Profile change in `morning.lua`: replaced `os.getenv("MAKEIT_CONFIG") or fallback`
with the injected `MAKEIT_CONFIG` global directly.

## Test Coverage Added

- BATS test: asserts the `hs` command string includes `MAKEIT_CONFIG=[=[$CONF_DIR]=]`
- Smoke test suite (`make smoke`): verifies dependencies installed and daemon boundary works
  - `dependency: hs is on PATH`
  - `dependency: Hammerspoon is running`
  - `dependency: lua is installed`
  - `daemon boundary: MAKEIT_CONFIG global is injected into Hammerspoon execution`

`make test` is now explicit (no glob) so smoke tests don't run in the default suite.

## Tasks

- [x] Diagnose root cause: Hammerspoon daemon does not inherit shell environment variables
- [x] Fix engine: inject `MAKEIT_CONFIG` as a Lua global in `run_profile`
- [x] Fix profile: update `morning.lua` to use injected global directly
- [x] Install updated binary via `make install`
- [x] Add BATS assertion: `hs` command includes `MAKEIT_CONFIG` global set to config dir
- [x] Add `tests/smoke.bats` with dependency and daemon boundary checks
- [x] Add `tests/smoke_probe.lua` fixture
- [x] Add `smoke` Makefile target; make `test` target explicit
- [x] Run `make test` (25/25) and `make smoke` (4/4) — all green
- [x] Manual verification: `makeit morning` ran successfully end-to-end
- [ ] True up stale project files (README, PLAN.md) to reflect smoke test suite and engine change
- [ ] Commit engine, profile, and test changes with descriptive message
- [ ] Push changes
- [ ] Move to `plans/completed/`
