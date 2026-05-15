# Solution: markdownlint scanning node_modules

Related problem:
[docs/problems/2026-05-15-markdownlint-node-modules-scan.md](../problems/2026-05-15-markdownlint-node-modules-scan.md)

## What failed

The Markdown lint command scanned third-party documentation under
`node_modules/`, which produced a flood of unrelated lint errors.

## What worked

Added `.markdownlintignore` with `node_modules/**` and the local virtual
environment directories, then kept the lint command simple with
`markdownlint "**/*.md"`.

## Why it worked

The ignore file gives the same lint scope on Windows and WSL without
depending on shell-specific glob handling.

## All commands run

```text
npm run lint:md
wsl bash -lc '
  cd "/mnt/c/Users/GITWi/OneDrive/Documents/New project" &&
  source .venv-fedora/bin/activate &&
  bash scripts/validate.sh
'
```
