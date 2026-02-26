# Claude Code + Git Worktrees — 2026-02-26

## How it works

`claude --worktree <name>` (or `-w`) creates an isolated checkout at
`.claude/worktrees/<name>` inside the repo, on a new branch `worktree-<name>`.
Each session has its own filesystem — multiple agents can work in parallel
without file conflicts.

Subagents via the Task tool also support this: `isolation: "worktree"` gives
a spawned agent its own worktree.

## Lifecycle

- **Creation:** Claude scaffolds the worktree and branch.
- **Exit with no changes:** worktree and branch are automatically removed.
- **Exit with changes:** Claude prompts keep or discard. If kept, you get back
  a branch to merge/rebase/PR into main yourself. Claude handles scaffolding;
  git handles reconciliation.

## What comes along

All tracked files are present — same history, same context files (`CLAUDE.md`,
`AGENTS.md`, `plans/`, etc.). Gitignored files do not come along. Local config
or credentials a profile depends on would be absent and could fail silently.

## Cross-repo work (makeit + makeit-profiles)

`makeit-profiles` sits at `../makeit-profiles` from the `makeit` root. From a
worktree at `.claude/worktrees/<name>`, that becomes `../../../makeit-profiles`
— fragile if hardcoded as a relative path.

Absolute paths are cleaner for cross-repo references from worktrees. Since
`makeit-profiles` is not under `makeit` version control, it's a fixed location
on disk regardless of which worktree is active.

## Parallel agents and makeit-profiles

The worktree boundary only protects `makeit`. If two worktree agents both write
to `makeit-profiles` simultaneously, there is no isolation between them — they're
editing the same files on disk. Needs coordination if running parallel agents
that both touch profiles.
