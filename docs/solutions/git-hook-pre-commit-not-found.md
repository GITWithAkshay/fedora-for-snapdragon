# Solution: git commit hook could not find pre-commit

Related problem:
[docs/problems/2026-05-15-git-hook-pre-commit-not-found.md](../problems/2026-05-15-git-hook-pre-commit-not-found.md)

## What failed

`git commit` invoked a pre-commit hook that pointed to the Fedora WSL
virtual environment, so the hook could not run from the normal Windows Git
environment.

## What worked

Reinstalled the hook from the Windows virtual environment by rerunning
`scripts/setup-dev-env.ps1`.

## Why it worked

The generated hook now points at
`C:\Users\GITWi\OneDrive\Documents\New project\.venv-windows\Scripts\python.exe`,
which is valid for local Windows commits.

## All commands run

```text
git commit -m "chore: set up dual-environment development tooling v0.1.1"
powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1
```
