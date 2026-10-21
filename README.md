# Coding Agent Best Practices

Drop-in configuration templates for AI coding agents, organized as five layers: always-on **rules**, on-demand **skills**, context-isolated **subagents**, deterministic **hooks and linters**, and cross-session **state**. The repo has one tree per tool: Claude Code, Cursor, Google Antigravity, Posit Assistant, Windsurf (Devin Desktop), Cline, and a Universal fallback built on `AGENTS.md` and Git hooks.

These templates accompany the guide **Template for Coding Agent Best Practices**:

- [Part 1: Architecture and Configuration](https://lyd1acla1r3.github.io/blog/template-for-coding-agent-best-practices-configuration.html), which explains why each layer exists.
- [Part 2: Setup Guide](https://lyd1acla1r3.github.io/blog/template-for-coding-agent-best-practices-guide.html), which walks through installing the layers step by step.

## The Five Layers

| Layer | Purpose | Shared source |
|---|---|---|
| Rules | Short, always-on instructions: agency, ground truth, planning gate, writing conventions, frozen paths | [core/rules/](core/rules/) |
| Skills | Workflows loaded on demand: `checkpoint`, `handoff`, `tree-of-thought`, `adversarial-self-audit`, `deep-research`, `autonomous-debugger` | [core/skills/](core/skills/) |
| Subagents | Isolated-context roles: `codebase-explorer`, `web-researcher`, `style-auditor` | [core/agents/](core/agents/) |
| Hooks and linters | Deterministic guards that block destructive commands, secret leaks, frozen-path writes, and prose hygiene problems | [core/githooks/pre-commit](core/githooks/pre-commit), [core/scripts/lint_prose.py](core/scripts/lint_prose.py) |
| State | A rolling session checkpoint, durable plans, and the config files the guards read | [core/state/](core/state/), [core/scripts/plan.sh](core/scripts/plan.sh) |

## Layout

```text
core/        Shared sources. Skills, scripts, pre-commit, and state files are copied
             byte for byte into every platform tree. Rules and subagents keep the same
             body, with tool-specific frontmatter added in each tree.
platforms/   One drop-in tree per tool. Copy the whole tree into a project root.
tests/       Hook test harness (synthetic vendor payloads) and the core/ sync check.
```

## Quick Start

Copy one platform tree into the root of the project, then turn on the Git backstop:

```bash
cp -R platforms/<tool>/. /path/to/your-project/
cd /path/to/your-project && git config core.hooksPath .githooks
```

| Tool | Tree | Entry points | One-time setup |
|---|---|---|---|
| Claude Code | [platforms/claude-code/](platforms/claude-code/) | `CLAUDE.md`, `.claude/` | Hooks and permissions live in `.claude/settings.json` |
| Cursor | [platforms/cursor/](platforms/cursor/) | `.cursor/rules/*.mdc`, `.cursor/hooks.json` | Hooks run only in a trusted workspace |
| Antigravity | [platforms/antigravity/](platforms/antigravity/) | `AGENTS.md`, `.agents/` | Merge `.agents/cli-settings.example.json` into the CLI settings |
| Posit Assistant | [platforms/posit-assistant/](platforms/posit-assistant/) | `AGENTS.md`, `.posit/assistant/` | Run `/trust` so project hooks and skills load |
| Windsurf (Devin Desktop) | [platforms/windsurf/](platforms/windsurf/) | `AGENTS.md`, `.devin/` | Merge `.devin/user-config.example.json` into the user config |
| Cline | [platforms/cline/](platforms/cline/) | `.clinerules/`, `.cline/skills/` | Turn on **Enable Hooks** in Cline settings |
| Universal | [platforms/universal/](platforms/universal/) | `AGENTS.md`, `.agents/skills/` | Git `pre-commit` is the only enforcement layer |

Tools without native subagent files (Posit Assistant, Cline in VS Code, Universal) ship the subagent roles as handoff prompts to run in a fresh session.

## Customize First

Several files are placeholders. Edit them before relying on the guards:

1. **Writing conventions:** replace the example rules in the `writing-style` rule with the team's own conventions. Source: [core/rules/writing-style.md](core/rules/writing-style.md).
2. **Restricted terms:** replace `restricted-org-example` in `.style-denylist.txt` with codenames, client names, or other terms that must never be committed. These terms are checked in prose and code.
3. **Banned phrases:** add prose-only phrases to `.style-phrases.txt`. Text inside code blocks is skipped.
4. **Frozen paths:** `.freeze-paths.txt` drives the Git `pre-commit` hook. The agent hooks (`guard-freeze.sh`, or the Cline `PreToolUse` script) and the permission deny lists in each tool's settings file use `published/` and `archive/` directly, so update them to match.
5. **Permissions and models:** review the allow, ask, and deny lists, and the model aliases in the subagent frontmatter, for each tool.
6. **Session state:** fill in the project name and frozen paths in `session_checkpoint.md`.

## Daily Use

- `bash scripts/plan.sh new <slug>` creates a dated plan in the tool's plans folder, and `active`, `list`, and `done <file>` manage it. The script finds the plans folder on its own, and the `PLANS_DIR` variable overrides it.
- `python3 scripts/lint_prose.py <files-or-dirs>` runs the same hygiene checks as the pre-commit hook: local home paths, credential prefixes, denylist terms, and banned phrases.
- The `checkpoint` and `handoff` skills close a session: they update `session_checkpoint.md`, archive a copy in `checkpoints/`, and print a bootstrap prompt for the next session.

## Tests

Requirements: bash, Git, Python 3.10 or later, and `jq`.

```bash
python3 tests/run_hook_tests.py      # every guard, allow and deny, per tool payload schema
python3 tests/check_core_sync.py     # platform trees still match core/
```

`run_hook_tests.py` pipes synthetic payloads, built from each vendor's documented hook input schema, into the hook scripts, and it checks each tool's own block signal (exit code 2, or a JSON decision on stdout). The payloads are synthetic, so a passing run shows that the scripts behave as documented. It does not show that a given tool version fires the hook. Run one live deny case in each tool after installing.

## Maintaining the Templates

`core/` is the single source. After editing a file there, apply the same change to each platform copy, then run `python3 tests/check_core_sync.py` to confirm nothing drifted.

## License

[MIT](LICENSE)
