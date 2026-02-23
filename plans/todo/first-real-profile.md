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

- [ ] Decide on a profile to write (morning recovery, work, studio, etc.)
- [ ] Set up config repo at chosen location with `make init`
- [ ] Write the profile iteratively — start simple, layer in complexity
- [ ] Write a unit test for it using the hs mock pattern
- [ ] Run it for real and note anything that doesn't work as expected
- [ ] Capture any missing capabilities or friction points as new story stubs

## Done looks like

- `makeit <profile>` restores a real working environment from a bare terminal
- Profile has a passing unit test
- Any discovered gaps are captured as stories
