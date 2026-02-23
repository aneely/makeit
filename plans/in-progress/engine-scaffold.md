# Engine Scaffold

Initial build of the makeit engine repo: shell wrapper, Makefile, scaffold files, BATS tests, git setup.

## Done

- `AGENTS.md` — working norms
- `CLAUDE.md` — one-line pointer to AGENTS.md
- `PLAN.md` — full architecture and decisions reference
- `README.md` — user-facing install and usage
- `.gitignore`
- `plans/`, `session-notes/` directory structure

## In Progress

- Planning phase: feature breakdown and backlog before any code is written

## Remaining

- `bin/makeit` — shell wrapper
- `Makefile` — install, uninstall, test, init targets
- `scaffold/work.lua` — sample profile
- `scaffold/work_test.lua` — sample Lua test with hs mock
- `scaffold/config.Makefile` — Makefile dropped into new config repos by make init
- `tests/bin/hs` — mock hs binary for BATS tests
- `tests/test_makeit.bats` — BATS tests for bin/makeit
- git init + first commit
