# Solution: step logger CRLF handling

Related problem:
[docs/problems/2026-05-15-step-log-crlf-reintroduced.md](../problems/2026-05-15-step-log-crlf-reintroduced.md)

## What failed

The first PowerShell logger implementation used `Add-Content`, which wrote
Windows-style CRLF endings into `docs/steps.md` and caused the
`mixed-line-ending` hook to fail.

## Alternatives evaluated

1. Change the logger to write LF explicitly with .NET file APIs.
   Trade-off: Slightly more code, but it fixes the root cause.
2. Disable the `mixed-line-ending` hook.
   Trade-off: Easier short term, but it weakens cross-platform protection.
3. Rely only on `.gitattributes` normalization.
   Trade-off: Helps at commit time, but does not stop repeated local churn.
4. Move all step logging to Bash.
   Trade-off: Works in WSL, but it makes Windows-side logging awkward.

## What worked

Updated `scripts/log-step.ps1` to read the existing file and rewrite it
with UTF-8 and explicit LF separators.

## Why it worked

The logger now honors the repository newline policy directly, so new step
entries no longer fight `pre-commit`.

## All commands run

```text
powershell -ExecutionPolicy Bypass -File .\scripts\log-step.ps1 ...
powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1
```
