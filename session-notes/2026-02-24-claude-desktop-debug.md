# Session Notes — 2026-02-24 (Claude Desktop Debugging)

## What Happened

Claude Desktop stopped showing its main window after a quit instead of a restart. Spent the
session diagnosing the root cause from first principles using logs and process inspection,
then performed a clean reinstall.

## Key Learnings

### Claude Desktop has a known zombie-state quit bug
Tracked in [anthropics/claude-code#14951](https://github.com/anthropics/claude-code/issues/14951).
`Cmd+Q` triggers the quit handler, which hides windows and logs "quitting" — but the process
doesn't exit. The window is hidden, the renderer is gone, and the app is stuck in a
neither-alive-nor-dead state. `killall -9 Claude` is the reliable fix.

### The Swift native layer is the canary
`~/Library/Logs/Claude/swift.log` gets an entry on every healthy startup. When the Swift
layer fails to initialize, no entry appears. Every broken session today had no swift.log
entry. Every working session did. This is the fastest way to confirm the app is actually
healthy vs. zombie.

### The renderer process is the other canary
Healthy Claude Desktop always has a `--type=renderer` Claude Helper process. A blank/
transparent window in Mission Control with no renderer process in `ps` means the app's
web content never loaded — regardless of what the main process logs say.

### Log file map
- `main.log` — Electron main process: startup, MCP, quit lifecycle
- `unknown-window.log` — renderer (web content) for the main chat window
- `swift.log` — native macOS Swift layer: hotkeys, fonts, window management
- `coworkd.log` — the gVisor VM that backs CoWork
- `vzgvisor.log` — VM network supervisor

### window-state.json is the Electron window position cache
Lives at `~/Library/Application Support/Claude/window-state.json`. Deleting it forces a
fresh window position on next launch. Safe to delete; regenerates automatically.

### Claude Desktop and Claude Code are fully separate processes
`killall Claude` (capital C) targets the Desktop app. Claude Code CLI is `claude`
(lowercase). No overlap; killing one never affects the other.

### AppCleaner is the right uninstall tool
Claude ships no uninstaller. AppCleaner (freemacsoft.net/appcleaner) finds all associated
support files, caches, prefs, and logs and shows a confirmation list before deleting.

### Conversation state syncs from account
No need to preserve `~/Library/Application Support/Claude/` before reinstalling. All
conversations live in the Anthropic account. Only `claude_desktop_config.json` is worth
preserving if MCP servers are configured.

### secureVmFeaturesEnabled: false breaks headless startup
`~/Library/Application Support/Claude/claude_desktop_config.json` accepts a
`preferences.secureVmFeaturesEnabled` key. Setting it to `false` causes Claude Desktop
to start headless — main process and helpers run, but no renderer spawns and the Swift
layer never initializes. No error is surfaced; the app just silently does not show a window.

This key is undocumented for individual users (Pro/Max). Team/Enterprise plans can disable
CoWork via Organization settings. There is no supported toggle for solo accounts.

Setting `secureVmFeaturesEnabled: false` before the app is authorized on a fresh install
is particularly destructive — the app appears to launch but is completely unusable.

**Current disposition:** leave `secureVmFeaturesEnabled` unset or `true`. The unofficial
toggle script (`toggle_claude_cowork`) does more harm than good and has been retired.

### clear.lua handles Claude Desktop's quit bug
`makeit clear` now calls `app:kill9()` instead of `app:kill()` for Claude Desktop,
matching the `killall -9 Claude` workaround. Claude is listed in a dedicated `kill9`
table in `clear.lua` for apps that ignore SIGTERM.

## What to Do Instead of Quitting Normally

```bash
killall -9 Claude
```

Until Anthropic fixes the quit bug, this is more reliable than `Cmd+Q` or Dock > Quit.
