# Engine Scaffold

Initial build of the makeit engine repo: shell wrapper, Makefile, scaffold files, BATS tests, git setup.

## Tasks

- [x] `AGENTS.md` — working norms
- [x] `CLAUDE.md` — one-line pointer to AGENTS.md
- [x] `PLAN.md` — full architecture and decisions reference
- [x] `README.md` — user-facing install and usage
- [x] `.gitignore`
- [x] `plans/`, `session-notes/` directory structure
- [x] `bin/makeit` — shell wrapper
- [x] `tests/bin/hs` — mock hs binary for BATS tests
- [x] `tests/test_makeit.bats` — BATS tests for bin/makeit
- [x] git init + initial commits
- [ ] `Makefile` — install, uninstall, test, init targets
- [ ] `scaffold/work.lua` — sample profile
- [ ] `scaffold/work_test.lua` — sample Lua test with hs mock
- [ ] `scaffold/config.Makefile` — Makefile dropped into new config repos by `make init`
