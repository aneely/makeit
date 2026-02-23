# make init

Wire up the `init` target in the Makefile so `make init` scaffolds a working config repo from the scaffold files. Validate the full new-user flow end to end.

## Tasks

- [x] Write BATS tests for `make init` behavior before implementing
- [x] Implement `init` target in `Makefile` — copy scaffold files into `CONFIG_DIR`, print setup instructions
- [x] Manual end-to-end test: run `make init`, then `makeit work`, confirm Finder opens
- [x] Update `PLAN.md` Makefile section to reflect final implementation

## Done looks like

- `make init` creates a config dir with `work.lua`, `tests/work_test.lua`, and `Makefile`
- `make init CONFIG_DIR=~/dev/my-profiles` works with a custom location and prints the export reminder
- Running `make init` twice does not overwrite existing files
- `make test` in the scaffolded config repo passes
- The full new-user flow in README works as documented
