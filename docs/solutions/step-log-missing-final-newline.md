# Solution: step logger final newline

Related problem:
[docs/problems/2026-05-15-step-log-missing-final-newline.md](../problems/2026-05-15-step-log-missing-final-newline.md)

## What failed

The revised PowerShell logger wrote LF separators but still omitted the
final newline at the end of `docs/steps.md`.

## What worked

Updated `scripts/log-step.ps1` so the composed entry string always ends
with `\n`.

## Why it worked

`end-of-file-fixer` expects a final newline. Adding it at write time keeps
the step log stable across both Windows and WSL validation.

## All commands run

```text
powershell -ExecutionPolicy Bypass -File .\scripts\log-step.ps1 ...
wsl bash -lc '
  cd "/mnt/c/Users/GITWi/OneDrive/Documents/New project" &&
  bash scripts/setup-wsl-fedora.sh
'
```
