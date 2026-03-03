#!/usr/bin/env bats

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'

  MAKEIT="$BATS_TEST_DIRNAME/../bin/makeit"
}

# ---------------------------------------------------------------------------
# Dependencies
# ---------------------------------------------------------------------------

@test "dependency: hs is on PATH" {
  run command -v hs
  assert_success
}

@test "dependency: Hammerspoon is running" {
  run pgrep -x Hammerspoon
  assert_success
}

@test "dependency: lua is installed" {
  run command -v lua
  assert_success
}

# ---------------------------------------------------------------------------
# Daemon boundary
# ---------------------------------------------------------------------------

@test "daemon boundary: MAKEIT_CONFIG global is injected into Hammerspoon execution" {
  run "$MAKEIT" "$BATS_TEST_DIRNAME/smoke_probe.lua"
  assert_success
}
