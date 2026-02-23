# onboarding: guide users toward a version-controlled config repo

Discovered during `make-init` build: the current default (`~/.config/makeit`) optimizes
for zero-friction first run but discourages the version-controlled, portable config repo
pattern that is a core project value.

## Decision needed

1. Should the default `CONFIG_DIR` change (e.g. to `~/dev/makeit-profiles`), or should
   `make init` actively prompt/guide the user to choose a location?
2. What does the README feature as the primary adoption path — zero-config default, or
   git repo from the start?

## Considered and set aside: two-tier sync approach

Discussed adding a `makeit sync` subcommand to copy profiles from a user-specified repo
into `~/.config/makeit`, separating version-controlled source from runtime location.

Rejected: introduces sync drift — editing a profile without syncing means `makeit` runs
the old version. `$MAKEIT_CONFIG` pointing directly at the repo already achieves the same
separation without copies or state. Also conflicts with the "no state tracking" design
principle. The env var is a one-time setup cost; drift is an ongoing runtime risk.

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

- [x] Decide: Option A — lead with git repo in README, keep default behavior, nudge via init output
- [x] Update `make init` output to include git init instructions after scaffolding
- [x] Update README new-user flow to feature the version-controlled pattern prominently
- [x] Update PLAN.md to reflect final decision
