# profile composition (spike)

Explore how profiles can be decomposed into smaller, independently runnable units that
can also be composed into larger profiles like `morning.lua`.

## Motivation

`morning.lua` does several distinct things: mounts drives, opens Finder windows, launches
apps, connects VPN. Each of these is useful on its own. A user should be able to run
`makeit mount-media` or `makeit open-finder-tabs` without running the full morning profile.
At the same time, `morning.lua` should be able to invoke these same units rather than
duplicating logic.

## Open Questions

1. **Naming convention** — flat files in config root (`mount-media.lua`) or a subdirectory
   (`lib/mount-media.lua`, `parts/`)? Subdirectory keeps the root clean but makes them
   less directly invocable unless the engine is taught to look there.

2. **Composition mechanism** — `dofile()` (simple, no module system) or `require()`
   (cleaner but path-sensitive)? `dofile()` with an absolute path is the current pattern;
   `require()` needs `package.path` set up.

3. **Where do generic utilities live?** — Some sub-profiles (`draw drives`, `shudder Finder`)
   are generic enough to be useful to any makeit user. Should they ship in `scaffold/` and
   get copied on `make init`, or live in the user's config repo? Scaffold keeps them
   universal; config repo keeps the engine lean. This is the key question the spike should
   answer.

4. **Profile contract** — if a sub-profile is designed to be both standalone and composable,
   does it need to behave differently in each context? Or is `dofile()` transparent enough
   that there's no distinction?

## Tasks

- [ ] Survey what `morning.lua` actually does that could stand alone
- [ ] Try extracting one unit (e.g. drive mounting) as a standalone profile and composing
      it back into `morning.lua` via `dofile()`
- [ ] Evaluate whether `require()` is worth the setup cost over `dofile()`
- [ ] Decide: scaffold-bundled utilities vs config-repo-only
- [ ] Document the pattern in PLAN.md if a clear convention emerges
- [ ] Move to `plans/completed/`
