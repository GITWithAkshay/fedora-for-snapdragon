#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$REPO_ROOT"

if [[ -x "$REPO_ROOT/.venv-fedora/bin/pre-commit" ]]; then
    "$REPO_ROOT/.venv-fedora/bin/pre-commit" run --all-files
else
    pre-commit run --all-files
fi

shellcheck scripts/*.sh
npx markdownlint "**/*.md"
echo "Validation completed successfully."
