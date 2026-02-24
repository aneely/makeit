# Agent autonomy modes

On a design-heavy project like makeit, tight collaborative mode — one action per exchange,
describe before writing, surface every choice — is essential for staying in control of how
things shape up. But for well-scoped execution tasks, that same discipline becomes friction.
A parallel or autonomous agent that stops after every action and waits for input isn't useful.

The goal is a clean way to operate in both modes without maintaining two separate AGENTS.md
files or mentally tracking which norms apply.

## Open questions

- Where does mode live? Options: a flag in AGENTS.md, a separate `AGENTS.autonomous.md`,
  per-task instructions passed to subagents at spawn time.
- How does a subagent inherit or override the parent's mode? Should autonomous tasks get
  a stripped-down AGENTS.md that just describes the task and omits collaboration norms?
- What does autonomous mode actually look like for this project in practice? Probably:
  implement a fully-specced story, run tests, surface a commit for review — no step-by-step
  check-ins, but still no commit without approval.
- Is this a Claude Code feature (custom agent types, keyed to AGENTS files) or just a
  documentation and workflow convention?
- Are there tasks that are clearly mode 1 vs. mode 2, or does it depend on the state of
  the design at the time?

## Notes

Claude Code's `Task` tool already supports spawning subagents with custom instructions.
The missing piece is a project-level convention for how to scope and hand off an autonomous
task cleanly — spec, constraints, success criteria — so the agent can run without check-ins
and produce something reviewable at the end.
