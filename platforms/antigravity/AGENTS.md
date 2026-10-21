# Project Operating Instructions (Google Antigravity)

## Active Architecture & State
- Read `session_checkpoint.md` at the start of every session before modifying files.
- Workspace rules load from `.agents/rules/*.md` using `trigger:` frontmatter (`always_on` or `glob`).
- On-demand skills live in `.agents/skills/<name>/SKILL.md`.
- Context-isolated subagents live in `.agents/agents/<name>.md` (`subagent: true`, `mainAgent: false`).
- Deterministic `PreToolUse` hooks are configured in `.agents/hooks.json` and return JSON `{"decision": "allow"|"deny"}` on stdout.
