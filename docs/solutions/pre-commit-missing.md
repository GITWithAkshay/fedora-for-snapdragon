# Solution: pre-commit missing

Related problem:
[docs/problems/2026-05-15-pre-commit-missing.md](../problems/2026-05-15-pre-commit-missing.md)

## What failed

Running `pre-commit --version` on Windows failed because the executable was
not installed in any active environment.

## What worked

Created a repository-local Windows virtual environment and installed
`pre-commit` from `requirements-dev.txt`.

## Why it worked

The repository now controls its own Python tooling instead of assuming a
global installation exists on the machine.

## All commands run

```text
python --version
pre-commit --version
powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1
```
