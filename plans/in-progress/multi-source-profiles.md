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

- **Sources file:** `~/.config/makeit/sources` lists profile source directories, one per line.
  The engine reads this file at startup. Arbitrary N sources supported.
- **Precedence:** first match wins. Place more specific sources earlier in the file.
- **No env var:** `$MAKEIT_CONFIG` is retired. The sources file is the single source of truth.
  This keeps complexity inside the tool rather than pushing shell config onto users.
- **Managed by the tool:** `makeit init` creates or appends to the sources file.
  `makeit adopt <dir>` registers an existing repo (fast-follow).
- **`makeit list`:** shows all profiles across all sources, annotated with source path.
  Duplicate names are shown with a `[shadowed]` marker on the losing entry.
- **MAKEIT_CONFIG Lua global:** when running a profile, the engine injects the source
  directory that contained the winning profile. This preserves the contract that profiles
  use `MAKEIT_CONFIG` to find sibling files (e.g. `dofile(MAKEIT_CONFIG .. "/lib/...")`).
- **Promotion:** user convention only; no `makeit promote` subcommand for now.
- **Machine identity:** handled by which sources are listed per machine, not by engine logic.

## Tasks

- [x] Establish baseline: run existing BATS tests green before touching anything
- [x] Design the search path resolution algorithm and document it in PLAN.md
- [ ] Extend `bin/makeit` to read `~/.config/makeit/sources` for profile resolution
- [ ] Update `makeit list` to show all profiles across all sources with source annotation and shadowing
- [ ] Update BATS tests to cover multi-source resolution and precedence
- [ ] Update `makeit init` to create/append to the sources file
- [ ] Move to `plans/completed/`
