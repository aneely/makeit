#!/usr/bin/env bats

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  load 'test_helper/bats-file/load'

  # Put mock hs on PATH so bin/makeit finds it instead of the real hs
  export PATH="$BATS_TEST_DIRNAME/bin:$PATH"

  MAKEIT="$BATS_TEST_DIRNAME/../bin/makeit"

  # Shared temp config dir; exported so tests can override with MAKEIT_CONFIG=...
  CONF_DIR=$(mktemp -d)
  export MAKEIT_CONFIG="$CONF_DIR"
}

teardown() {
  rm -rf "$CONF_DIR"
}

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------

@test "no arguments prints usage and exits 1" {
  run "$MAKEIT"
  assert_failure
  assert_output --partial "usage:"
}

# ---------------------------------------------------------------------------
# makeit list
# ---------------------------------------------------------------------------

@test "list: no config dir exits 1 with message" {
  MAKEIT_CONFIG="/tmp/nonexistent-makeit-$$" run "$MAKEIT" list
  assert_failure
  assert_output --partial "no config dir found"
}

@test "list: empty config dir exits 1 with message" {
  run "$MAKEIT" list
  assert_failure
  assert_output --partial "no profiles found"
}

@test "list: profiles in config dir are printed without .lua extension" {
  touch "$CONF_DIR/work.lua" "$CONF_DIR/studio.lua"

  run "$MAKEIT" list
  assert_success
  assert_output --partial "work"
  assert_output --partial "studio"
  refute_output --partial ".lua"
}

# ---------------------------------------------------------------------------
# makeit clear
# ---------------------------------------------------------------------------

@test "clear: no clear.lua exits 1 with message" {
  run "$MAKEIT" clear
  assert_failure
  assert_output --partial "no clear.lua found"
}

@test "clear: clear.lua exists runs it via hs dofile" {
  touch "$CONF_DIR/clear.lua"

  run "$MAKEIT" clear
  assert_success
  assert_output --partial "dofile"
  assert_output --partial "clear.lua"
}

# ---------------------------------------------------------------------------
# makeit <file.lua> — direct file path
# ---------------------------------------------------------------------------

@test "file: missing file reports original argument in error" {
  run "$MAKEIT" ./nonexistent.lua
  assert_failure
  assert_output --partial "./nonexistent.lua"
}

@test "file: ./file.lua (dot-slash prefix) runs via hs dofile" {
  touch "$CONF_DIR/script.lua"

  run "$MAKEIT" "$CONF_DIR/script.lua"
  assert_success
  assert_output --partial "dofile"
}

@test "file: path/to/file.lua (contains slash) runs via hs dofile" {
  mkdir -p "$CONF_DIR/path/to"
  touch "$CONF_DIR/path/to/script.lua"

  run "$MAKEIT" "$CONF_DIR/path/to/script.lua"
  assert_success
  assert_output --partial "dofile"
}

@test "file: ~/file.lua (tilde prefix) runs via hs dofile" {
  local tmpfile="$HOME/.makeit-test-$$.lua"
  touch "$tmpfile"

  run "$MAKEIT" "~/$(basename "$tmpfile")"
  assert_success
  assert_output --partial "dofile"

  rm -f "$tmpfile"
}

@test "file: file.lua (bare .lua extension) runs via hs dofile" {
  local tmpfile="$PWD/makeit-test-$$.lua"
  touch "$tmpfile"

  run "$MAKEIT" "$(basename "$tmpfile")"
  assert_success
  assert_output --partial "dofile"

  rm -f "$tmpfile"
}

# ---------------------------------------------------------------------------
# makeit <profile> — named profile lookup
# ---------------------------------------------------------------------------

@test "profile: no config dir exits 1 with message" {
  MAKEIT_CONFIG="/tmp/nonexistent-makeit-$$" run "$MAKEIT" work
  assert_failure
  assert_output --partial "no config dir found"
}

@test "profile: profile not found exits 1 with name in error" {
  run "$MAKEIT" work
  assert_failure
  assert_output --partial "profile not found"
  assert_output --partial "work"
}

@test "profile: profile not found lists available profiles" {
  touch "$CONF_DIR/studio.lua"

  run "$MAKEIT" work
  assert_failure
  assert_output --partial "studio"
}

@test "profile: found profile runs via hs dofile" {
  touch "$CONF_DIR/work.lua"

  run "$MAKEIT" work
  assert_success
  assert_output --partial "dofile"
  assert_output --partial "work.lua"
}

# ---------------------------------------------------------------------------
# Preflight dependency checks
# ---------------------------------------------------------------------------

@test "preflight: hs not found exits 1 with message" {
  touch "$CONF_DIR/work.lua"
  PATH="/usr/bin:/bin" run "$MAKEIT" work
  assert_failure
  assert_output --partial "hs not found"
}

@test "preflight: Hammerspoon not running exits 1 with message" {
  touch "$CONF_DIR/work.lua"
  local fake_bin
  fake_bin=$(mktemp -d)
  printf '#!/bin/sh\nexit 1\n' > "$fake_bin/pgrep"
  chmod +x "$fake_bin/pgrep"
  PATH="$fake_bin:$BATS_TEST_DIRNAME/bin:$PATH" run "$MAKEIT" work
  assert_failure
  assert_output --partial "Hammerspoon"
  rm -rf "$fake_bin"
}
