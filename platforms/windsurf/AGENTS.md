# Project Operating Instructions (Windsurf / Devin Desktop)

## Surface Note
- **Devin Local (Primary):** Loads `AGENTS.md`, `.devin/rules/*.md`, `.devin/skills/<name>/SKILL.md`, `.devin/agents/<name>.md`, `.devin/hooks.v1.json`, and `.devin/config.json`.
- **Legacy Cascade Compatibility:** Legacy Windsurf Cascade editors read `.windsurf/rules/*.md` and `.devin/hooks.json` (`pre_run_command`, `pre_write_code`). The hook scripts in `.devin/hooks/` inspect both Devin Local (`tool_input`) and legacy Cascade (`tool_info`) JSON fields so one script suite serves both surfaces.
