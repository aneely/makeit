# hs extension loading output

On first invocation after a cold start, Hammerspoon prints extension loading lines to
stdout:

```
-- Loading extension: application
-- Loading extension: timer
```

These do not appear on subsequent runs once extensions are cached. The output is harmless
but noisy and may confuse users or interfere with scripted use.

## Tasks

- [ ] Confirm whether this output comes from `hs` itself or from the profile
- [ ] Determine if it can be suppressed (e.g. redirect stderr, suppress via hs flag)
- [ ] Decide whether to suppress, document, or leave as-is
- [ ] Move to `plans/completed/`
