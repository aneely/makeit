# lua doc comments

Adopt a structured Lua comment standard (LDoc) so agent sessions can get a comprehensive
view of the codebase from generated summaries rather than reading raw source files.

## Decision needed

- Confirm LDoc as the standard (vs. plain `---` conventions without a tool)
- Decide where generated output lives and whether it's committed or generated on demand
- Establish the comment discipline norm: what gets annotated (all public-facing functions?
  profiles? helpers only?)

## Tasks

- [ ] Evaluate LDoc: install, annotate a sample file, confirm plain-text output is
      agent-friendly
- [ ] Document the annotation convention in AGENTS.md
- [ ] Annotate existing source files (`bin/makeit`, scaffold files)
- [ ] Add a `make docs` target that emits a summary an agent can read in one pass
- [ ] Update PLAN.md to reference the docs target and convention
- [ ] Move to `plans/completed/`
