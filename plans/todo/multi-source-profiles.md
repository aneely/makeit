# multi-source profiles

Extend makeit to draw profiles from multiple sources with different trust and visibility
levels. Today `$MAKEIT_CONFIG` points at a single directory. A layered model lets users
maintain shareable public profiles alongside private, machine-specific, or in-progress
ones without entangling them.

## Motivating scenarios

- Profiles that are generically useful go in a public VCS repo; sensitive or personal ones
  stay untracked
- A work machine and a personal machine share some profiles but each has machine-specific
  ones that shouldn't cross over
- InfoSec: a profile that opens a bank or encodes which apps you use shouldn't be committed
  to a public repo
- Prototyping: write a profile fast with hardcoded credentials or paths, iterate until it
  works, then sanitize and promote a clean version to VCS

## Design direction

Extend `$MAKEIT_CONFIG` to a colon-separated search path (like `PATH`). The engine
searches sources left to right; first match wins. A local untracked directory can be
placed first to override or shadow public profiles.

```bash
export MAKEIT_CONFIG=~/.config/makeit-local:~/dev/my-profiles
```

`makeit morning` resolves to the first `morning.lua` found across sources. `makeit list`
shows all profiles across all sources, annotated by which source each comes from.

A well-known local fallback (e.g. `~/.config/makeit-local/`) could be prepended
automatically without requiring env var changes.

## Open questions

1. **Precedence direction** — first match wins (local overrides shared) or last match wins
   (shared overrides local)? First match wins is more intuitive for overrides.

2. **Auto-prepended local source** — should the engine always prepend a well-known
   untracked location (e.g. `~/.config/makeit-local/`) so private profiles work without
   any env var changes? Or keep it explicit?

3. **`makeit list` display** — show source alongside profile name? How to handle the same
   profile name appearing in multiple sources?

4. **Promotion workflow** — is this purely a user convention (copy file, sanitize, commit)
   or does makeit get a `makeit promote <profile>` command to assist?

5. **Machine identity** — machine-specific profiles could live in a machine-named source
   dir, or be gated inside the profile via hostname/env var checks. Which belongs in the
   engine vs in Lua?

## Tasks

- [ ] Establish baseline: run existing BATS tests green before touching anything
- [ ] Design the search path resolution algorithm and document it in PLAN.md
- [ ] Extend `bin/makeit` to accept a colon-separated `$MAKEIT_CONFIG`
- [ ] Update `makeit list` to show profiles across all sources with source annotation
- [ ] Update BATS tests to cover multi-source resolution and precedence
- [ ] Decide on auto-prepended local fallback and implement if chosen
- [ ] Document promotion convention (and `makeit promote` if warranted)
- [ ] Move to `plans/completed/`
