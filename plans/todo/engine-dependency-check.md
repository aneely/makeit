# engine: check dependencies before running a profile

`bin/makeit` currently assumes Hammerspoon is running and `hs` is installed. If either is
missing, the error is cryptic. A pre-flight check would surface a clear, actionable message.

## Tasks

- [ ] Check that `hs` is on PATH before attempting to run a profile
- [ ] Check that Hammerspoon is running (e.g. `pgrep Hammerspoon`)
- [ ] Print a clear error message if either check fails, with instructions to fix
- [ ] Add BATS tests for both failure cases
- [ ] Update PLAN.md
