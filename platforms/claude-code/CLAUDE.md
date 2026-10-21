# Project Operating Instructions (Claude Code)

## Active Architecture & State
- Read `session_checkpoint.md` at the start of every session before modifying files.
- Modular always-on rules load from `.claude/rules/` (`agency.md`, `ground-truth.md`, `planning-mode.md`, `freeze-paths.md`).
- Prose and documentation rules in `.claude/rules/writing-style.md` activate via `paths:` frontmatter on Markdown files.
- On-demand workflows live in `.claude/skills/` (`checkpoint`, `handoff`, `tree-of-thought`, `adversarial-self-audit`, `deep-research`, `autonomous-debugger`).
- Context-isolated subagents live in `.claude/agents/` (`codebase-explorer`, `web-researcher`, `style-auditor`).
