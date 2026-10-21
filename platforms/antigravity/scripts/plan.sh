#!/usr/bin/env bash
# Plan lifecycle helper: creates, lists, inspects, and archives durable markdown plans.
# Usage:
#   bash scripts/plan.sh new <slug>
#   bash scripts/plan.sh list
#   bash scripts/plan.sh active
#   bash scripts/plan.sh done <plan-file>
#
# The plans folder is detected from the first existing tool folder below, so the
# same script works in every platform tree. Set PLANS_DIR to override detection.

set -euo pipefail

if [ -z "${PLANS_DIR:-}" ]; then
  PLANS_DIR="plans"
  for CANDIDATE in .claude/plans .cursor/plans .agents/plans .posit/assistant/plans .devin/plans; do
    if [ -d "$CANDIDATE" ]; then
      PLANS_DIR="$CANDIDATE"
      break
    fi
  done
fi
DONE_DIR="$PLANS_DIR"
DONE_DIR+="/archive"

CMD="${1:-list}"

case "$CMD" in
  new)
    SLUG="${2:-}"
    if [ -z "$SLUG" ]; then
      echo "Error: missing plan slug. Usage: bash scripts/plan.sh new <slug>" >&2
      exit 1
    fi
    mkdir -p "$PLANS_DIR"
    DATE_STR=$(date +%Y-%m-%d)
    PLAN_PATH="$PLANS_DIR"
    PLAN_PATH+="/"
    PLAN_PATH+="$SLUG"
    PLAN_PATH+="_"
    PLAN_PATH+="$DATE_STR"
    PLAN_PATH+=".md"
    if [ -f "$PLAN_PATH" ]; then
      echo "Plan already exists: $PLAN_PATH"
      exit 0
    fi
    cat <<'EOF' > "$PLAN_PATH"
# Implementation Plan

- **Status:** DRAFT (Requires explicit user approval before code edits)
- **Restore Point SHA:** <record git rev-parse HEAD before integration edits>

## 1. Objective & Scope
State the engineering goal and list out-of-scope directories.

## 2. Candidate Approaches (Tree of Thought)
| Branch | Summary | Key Tradeoff | Verdict |
|---|---|---|---|
| A | Candidate approach A | Tradeoff A | Reject / Selected |
| B | Candidate approach B | Tradeoff B | Reject / Selected |
| C | Candidate approach C | Tradeoff C | Reject / Selected |

## 3. Proposed File Changes
1. `path/to/file`: Description of modification.

## 4. Verification Commands
1. `python3 scripts/lint_prose.py <target>`
2. `<test command>`

## 5. Rollback Plan
1. `git checkout -- <paths>`
EOF
    echo "Created plan: $PLAN_PATH"
    ;;
  list)
    mkdir -p "$PLANS_DIR"
    echo "Active plans in $PLANS_DIR:"
    find "$PLANS_DIR" -maxdepth 1 -name "*.md" -print | sort
    ;;
  active)
    mkdir -p "$PLANS_DIR"
    LATEST=$(
      find "$PLANS_DIR" -maxdepth 1 -name "*.md" -print | sort | tail -n 1
    )
    if [ -z "$LATEST" ]; then
      echo "No active plans found in $PLANS_DIR"
      exit 0
    fi
    echo "Active plan: $LATEST"
    cat "$LATEST"
    ;;
  done)
    TARGET="${2:-}"
    if [ -z "$TARGET" ]; then
      echo "Error: specify the plan file to archive." >&2
      exit 1
    fi
    mkdir -p "$DONE_DIR"
    SRC_FILE="$TARGET"
    if [ ! -f "$SRC_FILE" ]; then
      SRC_FILE="$PLANS_DIR"
      SRC_FILE+="/"
      SRC_FILE+="$TARGET"
    fi
    if [ ! -f "$SRC_FILE" ]; then
      echo "Error: plan file not found: $TARGET" >&2
      exit 1
    fi
    MOVE_CMD=(mv "$SRC_FILE")
    MOVE_CMD+=("$DONE_DIR")
    "${MOVE_CMD[@]}"
    echo "Archived plan to $DONE_DIR/"
    ;;
  *)
    echo "Usage: bash scripts/plan.sh {new <slug>|list|active|done <file>}" >&2
    exit 1
    ;;
esac
