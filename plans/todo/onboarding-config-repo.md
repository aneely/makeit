# onboarding: guide users toward a version-controlled config repo

Discovered during `make-init` build: the current default (`~/.config/makeit`) optimizes
for zero-friction first run but discourages the version-controlled, portable config repo
pattern that is a core project value.

## Decision needed

1. Should the default `CONFIG_DIR` change (e.g. to `~/dev/makeit-profiles`), or should
   `make init` actively prompt/guide the user to choose a location?
2. What does the README feature as the primary adoption path — zero-config default, or
   git repo from the start?

## Constraints to keep in mind

- Portability is a stated core value: config repo should be independently version-controlled
  and machine-portable
- `~/.config/makeit` as a fallback for quick scripts / no-repo usage is still useful
- Whatever we decide, `make init CONFIG_DIR=<path>` already works — this is about what
  we encourage by default and how the onboarding copy frames it

## Observations from first manual end-to-end test (2026-02-23)

- `makeit: command not found` after `make init` — `make install` hasn't been run, so
  `~/.local/bin` isn't on PATH. The new-user README flow needs to address PATH setup
  explicitly, including where `make install` fits in the sequence.
- `./bin/makeit work` works fine as a workaround, but a new user following the README
  shouldn't need to know that. The onboarding flow should either run `make install` first
  or set expectations clearly.

## Tasks

- [ ] Decide: change default, guide via init, or just lead with git repo in README
- [ ] Update `make init` behavior and/or output to reflect decision
- [ ] Update README new-user flow to feature the version-controlled pattern prominently
- [ ] Update PLAN.md to reflect final decision
