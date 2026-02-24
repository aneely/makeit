# finder windows: tabs and network volume

Update a real profile to open two Finder windows on startup: one with tabs for local
directories, and one showing a mounted SMB network volume. Scope is current login session
only — cold-restart integration (ensuring the volume is available before the profile runs)
is a follow-on exercise tracked in `cold-start-validation.md`.

## Prior art

Both patterns rely on `hs.osascript.applescript()`. Finder's AppleScript dictionary has no
native `make new tab` verb.

The SMB pattern is split into two explicit steps: mount the volume (with a poll loop), then
open it in a separate Finder window. Keeps the timing concern isolated in the mount step and
leaves the window-open step usable independently (important for cold-restart variation).

### Pattern: tabbed Finder window

The `folders open in new tabs of Finder preferences` preference manipulation approach was
tested and does not work on Sequoia — Finder ignores the preference and opens separate
windows regardless. The working approach uses `System Events` to send `⌘T` after opening
the first window, then navigates the new tab to the second path.

Requires Hammerspoon to have Accessibility permission (System Settings > Privacy & Security
> Accessibility). When run via `hs.osascript.applescript()`, it is Hammerspoon — not
`osascript` directly — that sends the keystroke, so the permission applies to Hammerspoon.app.

```applescript
tell application "Finder"
    activate
    make new Finder window
    set target of front Finder window to home
end tell

tell application "System Events"
    tell process "Finder"
        keystroke "t" using command down
    end tell
end tell

tell application "Finder"
    set target of front Finder window to folder "Downloads" of home
end tell
```

Verified working on Sequoia.

### Pattern: mount SMB volume

```applescript
tell application "Finder"
    if "SHARE_NAME" is not in (list disks) then
        mount volume "smb://SERVER/SHARE_NAME"
    end if
    with timeout of 120 seconds
        repeat until exists disk "SHARE_NAME"
            delay 1.0
        end repeat
    end with timeout
end tell
```

`SHARE_NAME` is the disk name macOS assigns after mounting — typically the share component
of the URL, but the server may advertise a different display name. Must be verified against
the real server.

### Pattern: open mounted volume in a separate Finder window

The preference manipulation approach is unreliable on Sequoia (see above). Since `open disk`
opens a new window by default when no Finder window with that target already exists, the
simpler form is preferred. If the system tab preference is set to "Always", the preference
toggle may still be needed — verify during smoke test.

```applescript
tell application "Finder"
    activate
    open disk "SHARE_NAME"
end tell
```

## Placement in profile

Both the mount step and the Finder window opens belong inside the VPN gate callback —
the network volume is unreachable until VPN is connected.

## Tasks

- [x] Verify tab approach on target machine — preference manipulation does not work on
      Sequoia; confirmed ⌘T via System Events produces a single tabbed window
- [x] Verify the disk name the server assigns to the mounted volume — confirmed it matches the share component of the URL
- [x] Write the tabbed Finder window call in the profile (~ and ~/Downloads)
- [x] Write the mount step in the profile
- [x] Write the separate Finder window open for the mounted volume
- [x] Smoke test the full profile run in a live login session
- [x] No preference-state timing issues observed; clean run after permissions granted

## Out of scope (follow-on)

Cold-restart behavior — ensuring the network volume is available when the machine comes
back up — is intentionally deferred to `cold-start-validation.md`.
