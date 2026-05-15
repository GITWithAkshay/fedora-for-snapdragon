# Solution: enforce Docker native command exit checks in PowerShell

Related problem:
[docs/problems/2026-05-16-powershell-docker-exit-code-not-checked.md](../problems/2026-05-16-powershell-docker-exit-code-not-checked.md)

## What failed

`scripts/validate-docker.ps1` called Docker CLI commands directly and then
printed a success message even when `docker image inspect` failed because
the requested image tag did not exist yet.

## What worked

Wrapped Docker CLI calls in a helper that checks `$LASTEXITCODE` after each
native command and throws if Docker returned a non-zero status. Then built
the `0.1.4` image tag and reran the validation helper.

## Why it worked

PowerShell does not automatically turn every failing native command into a
terminating script error. Checking `$LASTEXITCODE` makes Docker failures
explicit and keeps the validation helper truthful.

## All commands run

```text
powershell -ExecutionPolicy Bypass -File .\scripts\validate-docker.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\run-book4edge-docker-build.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\validate-docker.ps1
```
