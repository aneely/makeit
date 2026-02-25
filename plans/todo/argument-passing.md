# argument passing

Extend `bin/makeit` to forward trailing arguments to the Lua profile as a global, enabling
`makeit <profile> [args...]` and the `makeit <verb> <noun>` usage pattern.

## Motivation

Profiles are currently execute-only with no way to parameterize them from the command line.
Supporting arguments unlocks a new class of focused, reusable profiles:

```bash
makeit shudder Finder        # close all Finder windows
makeit shudder Safari        # close all Safari windows
makeit left 33 Safari        # gather Safari windows to left 33% of screen
makeit draw drives           # open Finder windows for all mounted drives
```

`shudder`, `left`, and `draw` are profiles. `Finder`, `Safari`, `33`, `drives` are args
passed to them. The engine stays dumb — it routes, the profile interprets.

## Design

Inject trailing args as a Lua global before `dofile()`. Example invocation:

```bash
makeit shudder Finder
# engine runs:
# hs -c "args = {'Finder'}; dofile([==[/path/to/shudder.lua]==])"
```

The profile accesses `args[1]`, `args[2]`, etc. No args means `args` is an empty table
or nil — profile authors should guard accordingly.

## Tasks

- [ ] Establish baseline: run existing BATS tests green before touching anything
- [ ] Extend `bin/makeit` to capture and inject trailing args as a Lua global
- [ ] Update BATS tests to cover arg forwarding (with and without args)
- [ ] Write a sample parameterized profile (`shudder.lua` or similar) to validate the
      end-to-end UX
- [ ] Document the `args` global in PLAN.md under Profile Patterns
- [ ] Move to `plans/completed/`
