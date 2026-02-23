# first real profile

Write and use a real makeit profile for an actual daily workflow. This is the first
real-world exercise of the tool beyond the sample `work.lua` scaffold.

## Prerequisites

- Set up a version-controlled config repo at a chosen location
- `make install` run so `makeit` is on PATH
- `$MAKEIT_CONFIG` set in `.zshrc`

## Goals

- Validate the full stack end-to-end with real apps and real window/display state
- Surface any rough edges in the Hammerspoon API usage or profile authoring experience
- Identify missing capabilities or helpers worth building

## Tasks

- [x] Decide on a profile to write (morning recovery)
- [x] Set up config repo at chosen location with `make init`
- [x] Get apps launching — core applications open in sequence
- [x] Write a unit test for the profile using the hs mock pattern
- [x] Run it live and confirm it works end-to-end
- [x] Add utility apps and background tools
- [x] Tackle order-dependent launches (gating on network/VPN/etc.)
- [x] Capture any discovered gaps as new story stubs

## Done looks like

- `makeit <profile>` restores a real working environment from a bare terminal
- Profile has a passing unit test
- Any discovered gaps are captured as stories
