# multi-source profiles

Extend makeit to draw profiles from multiple sources with different trust and visibility
levels. Today `$MAKEIT_CONFIG` points at a single directory. A layered model lets users
maintain shareable public profiles alongside private, machine-specific, or in-progress
ones without entangling them.

## Motivating scenarios

- Profiles that are generically useful go in a public VCS repo; sensitive or personal ones
  stay private
- A work machine and personal machines share some profiles but each has machine-specific
  ones that shouldn't cross over
- Prototyping: write a profile fast, iterate until it works, then sanitize and promote a
  clean version to a tracked repo

## Design decisions

- **Search path:** `$MAKEIT_CONFIG` is a colon-separated list of directories (like `PATH`).
  Arbitrary N sources supported.
- **Precedence:** first match wins. Place more specific sources earlier in the path.
- **No auto-prepend:** the engine does not silently add any well-known location. `$MAKEIT_CONFIG`
  fully describes the search path. Adding a scratchpad dir is explicit.
- **`makeit list`:** shows all profiles across all sources, annotated with source path.
  Duplicate names are shown with a `[shadowed]` marker on the losing entry.
- **Promotion:** user convention only; no `makeit promote` subcommand for now.
- **Machine identity:** handled by configuring `$MAKEIT_CONFIG` per machine, not by engine logic.

## Notes

- Adoption friction: after `makeit init`, the user still has to wire the new dir into
  `$MAKEIT_CONFIG` before profiles run. This gap is a fast-follow — likely an `adopt`
  subcommand or an update to `makeit init` output.

## Tasks

- [ ] Establish baseline: run existing BATS tests green before touching anything
- [ ] Design the search path resolution algorithm and document it in PLAN.md
- [ ] Extend `bin/makeit` to accept a colon-separated `$MAKEIT_CONFIG`
- [ ] Update `makeit list` to show all profiles across all sources with source annotation and shadowing
- [ ] Update BATS tests to cover multi-source resolution and precedence
- [ ] Move to `plans/completed/`
