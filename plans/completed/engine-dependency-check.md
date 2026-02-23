# engine: check dependencies before running a profile

`bin/makeit` currently assumes Hammerspoon is running and `hs` is installed. If either is
missing, the error is cryptic. A pre-flight check would surface a clear, actionable message.

## Tasks

- [x] Check that `hs` is on PATH before attempting to run a profile
- [x] Check that Hammerspoon is running (e.g. `pgrep Hammerspoon`)
- [x] Print a clear error message if either check fails, with instructions to fix
- [x] Add BATS tests for both failure cases
- [x] Update PLAN.md
