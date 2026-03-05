# engine: profile observability and troubleshooting

Currently `bin/makeit` runs `hs -c "dofile(...)"` and returns whatever exit code `hs`
produces. There is no visibility into what a profile did or why something went wrong.

## Goal

Make it easy to understand what a profile did and why something went wrong — not just
whether it succeeded. Exit code propagation is a non-goal for now.

## Findings from spike

- `os.exit()` from a profile disrupts the Hammerspoon daemon (exits with 69) — ruled out
- Sentinel file works but leaks the mechanism into every profile that wants to signal failure
- A `makeit.abort()` helper hides the file I/O but still requires an explicit `return` from
  the caller — limited payoff
- Silent failures (e.g. uninstalled app) are invisible regardless of mechanism — profiles
  don't check return values by default
- The real need is troubleshooting visibility, not shell exit codes
- Structured logging (`makeit.log`, `makeit.launch`) is promising but async profiles
  (`hs.timer.waitUntil`) complicate when output is available. Not enough clarity yet on the
  full shape of the solution to start implementing.

## Tasks

- [ ] Decide on the observability model (structured logging, summary output, or other)
- [ ] Prototype against `morning.lua` — verify it works cleanly with async profiles
- [ ] Implement in `bin/makeit` and provide profile-side API
- [ ] Update BATS tests
- [ ] Update PLAN.md
- [ ] Move to `plans/completed/`

## Related

`smb-mount-timeout.md` depends on this story. Once profiles can signal failure, the mount
timeout can use that mechanism rather than silently returning 0.
