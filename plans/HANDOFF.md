# Handoff

Read `AGENTS.md`, `PLAN.md`, and `plans/in-progress/hs-ipc-cold-start.md`.

Ghostty cold-start window fix is in progress. `initial-window = true` is set in the
Ghostty config but does not open a window on login-item launch (Ghostty appears in Dock
with no window). Added `hs.timer.doAfter(5, ...)` to `~/.hammerspoon/init.lua` to
activate Ghostty 5 seconds after Hammerspoon loads, which should trigger `initial-window`.
User restarted to validate.

Next task: confirm whether Ghostty opens a window on cold start. If yes, check off the
validation task and `git mv` the story to `plans/completed/`. If no, tune the delay or
explore alternative approaches.
