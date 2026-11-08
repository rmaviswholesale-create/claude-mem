#!/bin/bash
set -euo pipefail

# Only needed in Claude Code cloud sessions; local machines manage their own deps.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}"

# Install global tools here, and only those that are missing.
# Bun runs the test suite (`bun test`).
if ! command -v bun >/dev/null 2>&1; then
  npm install -g bun
fi

# Run the install only if a listed file has changed since the install last succeeded.
hashes=node_modules/.session-start.sha256
if ! sha256sum --check --status "$hashes" 2>/dev/null; then
  # Delete the old hashes first, so a failed install runs again next time
  rm -f "$hashes"

  npm install

  # List this script and every file that decides what gets installed
  sha256sum .claude/hooks/session-start.sh package.json > "$hashes"
fi
