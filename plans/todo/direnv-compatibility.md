# direnv compatibility

direnv is a common tool for managing per-directory environment variables via `.envrc`
files. Since `$MAKEIT_CONFIG` is the primary configuration mechanism for makeit, ensuring
clean compatibility with direnv is worth validating — both for the author's own setup and
for potential contributors who use direnv.

## Tasks

- [ ] Install direnv if not already present (`brew install direnv`)
- [ ] Hook direnv into shell (`eval "$(direnv hook zsh)"` in `.zshrc`)
- [ ] Confirm `$MAKEIT_CONFIG` set via `.envrc` is picked up correctly by `makeit`
- [ ] Consider whether a `.envrc` in the config repo is a useful pattern to document
- [ ] Update README or PLAN.md if direnv is a recommended setup path
