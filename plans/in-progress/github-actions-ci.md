# GitHub Actions CI

## Goal

Run `make test` on every push and pull request to main. The test suite is fully
hermetic — vendored bats helpers, mock `hs` binary — so no macOS APIs are needed.
Use `ubuntu-latest` to keep runner costs low.

Smoke tests (`make smoke`) require a live Hammerspoon instance and are intentionally
excluded from CI.

## Decisions

- **Runner:** `ubuntu-latest` — hermetic tests have no macOS dependency; ~10x cheaper than macOS runners
- **Trigger:** `push` and `pull_request` on `main`
- **bats install:** `sudo apt-get install -y bats` — available in Ubuntu apt, no extra action needed
- **Vendored deps:** `tests/test_helper/` is already in the repo; no install step needed for helpers

## Workflow file

`.github/workflows/test.yml`

## Tasks

- [ ] Create `.github/workflows/test.yml`
- [ ] Verify CI passes on push
- [ ] Move to `plans/completed/`
