# makeit — Working Norms

## Collaboration Style

I want to be actively involved in every design and build decision. Do not proceed from one step to the next without my input. One move, then stop, then wait for my response — no exceptions, regardless of how clear the next step seems.

This applies to everything: reading a file and sharing observations, making a proposal, asking a question, running a command. One action per exchange.

Completing a task without user input at each step is a failure, not an accomplishment. A finished artifact the user didn't shape is the wrong outcome. The measure of a good session is whether the user was involved in every decision, not whether code was produced.

## Session Management

Work is tracked as a kanban across `plans/`:
- `plans/todo/` — upcoming features, not yet started
- `plans/in-progress/` — active work; one file per feature, doubles as session context
- `plans/completed/` — finished features, archived for reference
- `session-notes/YYYY-MM-DD.md` — freeform notes, decisions, retro material

**Starting a session:** read `AGENTS.md`, `PLAN.md`, and the relevant `plans/in-progress/` file.

**Ending a session ("let's hand off"):** update the in-progress file (Done, In Progress, Remaining sections), then append or update the `## Handoff` section with a ready-to-paste continuation prompt:
> Read `AGENTS.md`, `PLAN.md`, and `plans/in-progress/<feature>.md`. [One sentence on current state.] Next task: [specific next action].

When context is getting heavy, "let's hand off" is the cue to exit cleanly before compaction forces it.

## Code Style

Prefer modular, composable code over long procedures. Encapsulate concepts, name them explicitly, and structure functions so they can be reasoned about in terms of inputs and outputs. Side effects should be explicit, not buried. When there's a choice between a short procedure and a named abstraction, prefer the abstraction if the concept is likely to change or be reused.

## How We Work Together

1. **Describe before writing.** For each file or change, explain what it does and any non-obvious choices before creating or modifying it. Wait for a green light.

2. **Surface choices explicitly.** When there's more than one reasonable approach, present the options with tradeoffs. Don't silently pick one.

3. **One logical unit at a time.** A file, a test, a feature. Review and understand it before moving to the next.

4. **No commits without explicit approval.** Stage and describe what would be committed, wait for a green light. Never amend a published commit.

5. **Tests before implementation.** Write the test spec first so we agree on expected behavior before writing the code it exercises.

6. **Flag uncertainty.** If something is a guess — a Hammerspoon API, a shell edge case, anything — say so rather than presenting it as settled fact.

7. **Don't build ahead.** Only implement what's been discussed and agreed. No "while I'm here" additions.

## Project Context

makeit is a terminal-first macOS environment recovery and context switching tool. The primary use case is restoring a complete working environment after a forced restart.

Key decisions are documented in `docs/plan.md`. Read it for architecture, capability layers, and the motivating profile.

### Architecture in brief

- `bin/makeit` — shell script, the entire engine
- Profiles are plain Lua files run via `hs -c "dofile(...)"`
- Config lives wherever `$MAKEIT_CONFIG` points; falls back to `~/.config/makeit/`
- `makeit <name>` resolves a profile by name; `makeit <file.lua>` runs any file directly
- No state tracking, no teardown — execute-only

### Stack

- Shell (bash) for the CLI wrapper
- Lua for profiles (run by Hammerspoon's `hs` CLI)
- BATS for shell wrapper tests
- Plain `lua` + hs mock for profile unit tests

### Key constraint

Hammerspoon must be installed and running as a login item. The `hs` binary is installed via `hs.ipc.cliInstall()` in the Hammerspoon console — one-time per machine.
