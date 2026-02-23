# engine: propagate profile errors and exit codes

Currently `bin/makeit` runs `hs -c "dofile(...)"` and returns whatever exit code `hs`
produces. A soft abort inside a profile (e.g. VPN timeout) exits with 0 even though the
profile did not complete. There is no way for a profile to signal failure back to the shell.

## Goal

Allow profiles to signal failure so the shell can act on it — display an error, chain
commands, or surface the problem to the user in a script context.

## Options to evaluate

- `os.exit(1)` from Lua — exits the `hs` process with a non-zero code, but may have
  side effects on the running Hammerspoon daemon
- A sentinel file written by the profile, checked by `bin/makeit` after `hs` returns
- `hs.execute` return value inspection — unclear if `hs` propagates Lua exit codes cleanly
- Structured output to stdout that `bin/makeit` parses

## Tasks

- [ ] Investigate how `hs` handles `os.exit()` calls from within `dofile()`
- [ ] Decide on the propagation mechanism
- [ ] Update `bin/makeit` to surface profile errors with a non-zero exit code
- [ ] Update BATS tests to cover error propagation
- [ ] Update PLAN.md
