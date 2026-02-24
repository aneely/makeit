# hs ipc cold start

On a bare restart, Hammerspoon launches as a login item but the IPC message port is not
immediately reachable. `makeit` fails with:

```
error: can't access Hammerspoon message port Hammerspoon; is it running with the ipc module loaded?
```

The fix is to run `hs.ipc.cliInstall()` once in the Hammerspoon console. This is a
one-time setup step, but it is not obvious and not currently surfaced in the onboarding
flow.

## Root cause

`hs.ipc.cliInstall()` installs the `hs` CLI binary — a one-time operation that persists.
But it does not load the IPC module on subsequent Hammerspoon starts. Without
`require("hs.ipc")` in `~/.hammerspoon/init.lua`, Hammerspoon does not listen on the IPC
port after a restart, so the `hs` binary has nothing to connect to.

The README described only the binary installation step and implied it was sufficient.

## Changes made

- Added `require("hs.ipc")` to `~/.hammerspoon/init.lua`
- Updated README to document both steps: binary install and `init.lua` require
- Added `initial-window = true` to Ghostty config — necessary but not sufficient on its
  own; Ghostty appears in the Dock on login-item launch but does not open a window
- Added `hs.timer.doAfter(5, function() hs.application.launchOrFocus("Ghostty") end)` to
  `~/.hammerspoon/init.lua` — activates Ghostty 5 seconds after Hammerspoon loads, which
  triggers `initial-window` and opens a window; validated on cold start

## Tasks

- [x] Determine whether `hs.ipc.cliInstall()` persists across restarts or must be re-run
- [x] If it must be re-run, explore whether it can be called automatically from `init.lua`
- [x] Improve the error message or README guidance so the fix is discoverable without reading the full docs
- [x] Investigate whether Ghostty can be told to open a new window on startup, not just launch
- [x] Validate on a real cold start: Hammerspoon IPC connects without manual steps, Ghostty opens a window
- [ ] Move to `plans/completed/`

## Handoff

Read `AGENTS.md`, `PLAN.md`, and `plans/in-progress/hs-ipc-cold-start.md`. All code changes are made and committed; the story is blocked on cold-start validation. Next task: do a full restart, confirm Hammerspoon IPC connects and Ghostty opens a window without any manual steps, then check off the validation task and `git mv` the story to `plans/completed/`.
