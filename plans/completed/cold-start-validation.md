# cold start validation

All live testing so far has been against already-running apps, exercising the `focus`
half of `launchOrFocus()`. The restart-recovery scenario — the primary use case — has not
been validated against a real bare restart.

## Tasks

- [x] Do a full machine restart
- [x] Confirm Hammerspoon launches as a login item
- [x] Run a profile from a bare terminal
- [x] Observe behavior and note rough edges as new stories

## Observations

Hammerspoon launched as a login item but the IPC message port was not reachable on first
use. The user had to manually run `hs.ipc.cliInstall()` in the Hammerspoon console before
`makeit` could connect. See: `hs-ipc-cold-start.md`.

On first run after a bare restart, the profile hung at the async timeout — the network
volume had not finished mounting before the timeout fired, and the expected window did not
appear. A second run succeeded cleanly. See: `smb-mount-timeout.md`.

On the first (cold) Hammerspoon invocation, extension loading lines printed to stdout.
Absent on subsequent runs once extensions were cached. See: `hs-extension-output.md`.

Exit code was 0 on both runs. The tool otherwise worked as intended once prerequisites
were in place.
