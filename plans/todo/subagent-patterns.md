# subagent patterns

Establish working patterns for subagent use in Claude Code sessions — both for context
management and for code quality via model diversity.

## Patterns to adopt

### Proactive context offloading
Subagents reduce primary agent context consumption. Reach for them early — before context
pressure — for research-heavy tasks (API exploration, documentation lookup, codebase
investigation) that don't need to live in the main context window. The right trigger is
"this is a lot of reading I won't need to refer back to directly" not "we're at 70%".

### Antagonistic code review
Claude reviewing its own code has blind spots. When code quality matters, recruit a
different model as an adversarial reviewer — deliberately choosing a model that didn't
write the code. In Claude Code this means using Task with a different model parameter
(`haiku`, `opus`, or a future non-Anthropic option if available). Frame the reviewer
prompt explicitly as antagonistic: find problems, challenge assumptions, don't defer.

## Tasks

- [ ] Identify the first natural opportunity to use a subagent for research offloading
- [ ] Run an antagonistic review on a non-trivial piece of code (e.g. bin/makeit)
- [ ] Evaluate: did it find anything the primary agent missed?
- [ ] If patterns prove useful, codify them in AGENTS.md
- [ ] Move to `plans/completed/`
