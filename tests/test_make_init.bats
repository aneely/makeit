#!/usr/bin/env bats

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  load 'test_helper/bats-file/load'

  REPO="$BATS_TEST_DIRNAME/.."
  CONFIG_DIR=$(mktemp -d)
  XDG_HOME=$(mktemp -d)
  export HOME="$XDG_HOME"
}

teardown() {
  rm -rf "$CONFIG_DIR" "$XDG_HOME"
}

# ---------------------------------------------------------------------------
# make init
# ---------------------------------------------------------------------------

@test "init: creates work.lua in config dir" {
  run make -C "$REPO" init CONFIG_DIR="$CONFIG_DIR"
  assert_success
  assert_file_exists "$CONFIG_DIR/work.lua"
}

@test "init: creates tests/work_test.lua in config dir" {
  run make -C "$REPO" init CONFIG_DIR="$CONFIG_DIR"
  assert_success
  assert_file_exists "$CONFIG_DIR/tests/work_test.lua"
}

@test "init: creates Makefile in config dir" {
  run make -C "$REPO" init CONFIG_DIR="$CONFIG_DIR"
  assert_success
  assert_file_exists "$CONFIG_DIR/Makefile"
}

@test "init: prints done message with git instructions" {
  run make -C "$REPO" init CONFIG_DIR="$CONFIG_DIR"
  assert_success
  assert_output --partial "Done. To version-control your profiles:"
  assert_output --partial "git init && git add . && git commit"
  assert_output --partial "Then: makeit work"
}

@test "init: registers config dir in sources file" {
  run make -C "$REPO" init CONFIG_DIR="$CONFIG_DIR"
  assert_success
  assert_output --partial "Registered $CONFIG_DIR"
  assert_file_exists "$XDG_HOME/.config/makeit/sources"
  assert grep -qxF "$CONFIG_DIR" "$XDG_HOME/.config/makeit/sources"
}

@test "init: does not duplicate config dir in sources file on second run" {
  make -C "$REPO" init CONFIG_DIR="$CONFIG_DIR" >/dev/null
  run make -C "$REPO" init CONFIG_DIR="$CONFIG_DIR"
  assert_success
  refute_output --partial "Registered"
  local count
  count=$(grep -cxF "$CONFIG_DIR" "$XDG_HOME/.config/makeit/sources")
  [ "$count" -eq 1 ]
}

@test "init: does not overwrite existing files on second run" {
  make -C "$REPO" init CONFIG_DIR="$CONFIG_DIR" >/dev/null
  echo "-- sentinel --" >> "$CONFIG_DIR/work.lua"

  run make -C "$REPO" init CONFIG_DIR="$CONFIG_DIR"
  assert_success
  assert grep -q "sentinel" "$CONFIG_DIR/work.lua"
}
