#!/usr/bin/env bats

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
  load 'test_helper/bats-file/load'

  REPO="$BATS_TEST_DIRNAME/.."
  CONFIG_DIR=$(mktemp -d)
}

teardown() {
  rm -rf "$CONFIG_DIR"
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

@test "init: custom CONFIG_DIR prints export reminder" {
  run make -C "$REPO" init CONFIG_DIR="$CONFIG_DIR"
  assert_success
  assert_output --partial "export MAKEIT_CONFIG=$CONFIG_DIR"
}

@test "init: default CONFIG_DIR does not print export reminder" {
  run make -C "$REPO" init CONFIG_DIR="$CONFIG_DIR" DEFAULT_CONFIG_DIR="$CONFIG_DIR"
  assert_success
  refute_output --partial "export MAKEIT_CONFIG"
}

@test "init: does not overwrite existing files on second run" {
  make -C "$REPO" init CONFIG_DIR="$CONFIG_DIR" >/dev/null
  echo "-- sentinel --" >> "$CONFIG_DIR/work.lua"

  run make -C "$REPO" init CONFIG_DIR="$CONFIG_DIR"
  assert_success
  assert grep -q "sentinel" "$CONFIG_DIR/work.lua"
}
