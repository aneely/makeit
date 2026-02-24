# makeit hs-setup subcommand

The `~/.hammerspoon/init.lua` setup steps are documented in the README but are manual.
A `makeit` subcommand could automate the parts that are mechanical and error-prone —
lowering the barrier for new adopters and making the glide path to a working cold-start
more reliable.

## Core insight

Hammerspoon as a single, well-understood login item is a better model than managing
multiple entries in System Settings. Apple's login item, launch agent, and background
process behavior is a hard-to-reason-about morass of inconsistent behavior. Once
Hammerspoon is in System Settings, everything else can be orchestrated from `init.lua`
under full user control — predictable ordering, no approval prompts, debuggable in Lua.

The Ghostty cold-start window problem surfaced this potential: the fix wasn't a Ghostty
setting, it was Hammerspoon activating Ghostty at the right moment. That pattern
generalizes.

## Scoping question for grooming

Is the core of this story `makeit setup` (automating init.lua bootstrap), or is it a
broader `makeit login` subcommand that lets users register arbitrary apps as
Hammerspoon-managed login items? These may be better as sequential stories.

Candidate interface:
```bash
makeit setup              # ensure require("hs.ipc") is in init.lua
makeit login "Ghostty"    # add a launchOrFocus timer for Ghostty to init.lua
makeit login "Ghostty" --delay 8
```

## Candidate steps for setup

- Ensure `require("hs.ipc")` is present in `~/.hammerspoon/init.lua`, appending if missing
- Reload Hammerspoon config after making changes

## Open questions

- Should `makeit login` be its own subcommand or part of `makeit setup`?
- What does the generated init.lua stanza look like — hardcoded delay, configurable?
- Should it be idempotent (safe to re-run)? Almost certainly yes.
- Should it prompt before modifying `init.lua`, or just report what it did?
- Hammerspoon itself still needs to be a System Settings login item manually — document
  clearly that this is the one prerequisite makeit cannot automate.

- [ ] Move to `plans/completed/`
