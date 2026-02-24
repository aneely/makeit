# smb mount timeout on cold start

On first run after a bare restart, a network volume may not finish mounting before the
async timeout fires. When this happens the expected window does not appear and the profile
completes silently with exit code 0. A second run succeeds once the volume is available.

The tool gives no indication that the timeout fired or that the volume was not ready. From
the user's perspective the profile just does nothing.

## Dependencies

Blocked by `engine-error-passthrough.md`. The propagation mechanism must exist before this
story can signal timeout failures rather than silently returning 0.

## Tasks

- [ ] Determine whether the mount can be detected as incomplete vs. absent
- [ ] Consider a user-visible message when the timeout fires (e.g. "volume not ready, skipping")
- [ ] Evaluate whether a retry loop or longer timeout would help on cold start
- [ ] Decide whether exit code should remain 0 when a step is skipped due to timeout
- [ ] Move to `plans/completed/`
