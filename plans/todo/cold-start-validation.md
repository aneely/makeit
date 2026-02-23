# cold start validation

All live testing so far has been against already-running apps, exercising the `focus`
half of `launchOrFocus()`. The restart-recovery scenario — the primary use case — has not
been validated against a real bare restart.

## Tasks

- [ ] Do a full machine restart
- [ ] Confirm Hammerspoon and Ghostty launch as login items without intervention
- [ ] Run `makeit morning` from a bare terminal
- [ ] Observe: do all apps launch? Does the VPN gate work correctly on cold start?
- [ ] Note any rough edges or unexpected behavior as new stories
