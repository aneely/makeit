# hs ipc cold start

On a bare restart, Hammerspoon launches as a login item but the IPC message port is not
immediately reachable. `makeit` fails with:

```
error: can't access Hammerspoon message port Hammerspoon; is it running with the ipc module loaded?
```

The fix is to run `hs.ipc.cliInstall()` once in the Hammerspoon console. This is a
one-time setup step, but it is not obvious and not currently surfaced in the onboarding
flow.

## Tasks

- [ ] Determine whether `hs.ipc.cliInstall()` persists across restarts or must be re-run
- [ ] If it must be re-run, explore whether it can be called automatically from `init.lua`
- [ ] Improve the error message or README guidance so the fix is discoverable without reading the full docs
- [ ] Move to `plans/completed/`
