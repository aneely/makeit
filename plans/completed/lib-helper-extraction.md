# lib helper extraction (spike)

Explore extracting repeated helper functions from profiles into shared lib files.

## Motivation

`morning.lua` defined several functions inline (`openFinderTabs`, `mountVolume`,
`openVolume`, `openExternalVolumesExcluding`) that had no reason to live only in
that file. Extracting them into a `lib/` directory makes them available to other
profiles without duplication.

## Decisions

- **Location** — `lib/` subdirectory in the config repo. Keeps helper code distinct
  from runnable profiles. Not directly invocable by name; that's intentional.

- **Composition mechanism** — `dofile()` with path built from `MAKEIT_CONFIG` env var
  (falling back to `$HOME/.config/makeit`), mirroring the engine's own resolution logic.
  No caching, no module system complexity.

- **Function scope** — functions must be defined without `local` in lib files so they
  become globals in the calling profile's environment via `dofile()`.

- **Test runner** — `MAKEIT_CONFIG=$(CURDIR)` set in the Makefile so lib paths resolve
  correctly when running tests from the repo root.

- **scaffold vs config-repo** — deferred. Premature to bundle lib files in scaffold
  before the pattern has more use. Would also introduce a version skew problem for
  existing installs without an update mechanism.

## Tasks

- [x] Survey what `morning.lua` actually does that could stand alone
- [x] Extract helper functions into `lib/finder.lua` and `lib/volume.lua`
- [x] Compose them back into `morning.lua` via `dofile()`
- [x] Evaluate `require()` vs `dofile()`
- [x] Move to `plans/completed/`
