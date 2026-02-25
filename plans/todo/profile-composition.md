# profile composition (spike)

Explore how one unit of profile work could be called from a larger profile,
and see how we like the pattern in practice.

## Motivation

`morning.lua` does several distinct things: mounts drives, opens Finder windows,
connects VPN, launches apps. Some of those could be meaningful profiles in their
own right — `mount-media`, for example. Rather than designing a composition system
upfront, try extracting one unit as a complete runnable profile, have `morning.lua`
call it via `dofile()`, and evaluate how the seam feels.

The question isn't whether it's technically possible — `dofile()` works. The question
is whether it feels right: does the profile boundary carry its weight, or does it
just add indirection?

## Tasks

- [ ] Pick one unit from `morning.lua` to extract as a standalone profile (e.g.
      `mount-media.lua`)
- [ ] Run it standalone with `makeit mount-media` and confirm it works
- [ ] Have `morning.lua` call it via `dofile()` and confirm the full profile still works
- [ ] Evaluate: does the seam feel right, or is it just indirection?
- [ ] Document the outcome — either as a pattern worth keeping or a reason not to
- [ ] Move to `plans/completed/`
