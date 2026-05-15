# Solution: inline WSL build command lost its output path

Related problem:
[docs/problems/2026-05-15-inline-build-command-path-empty.md](../problems/2026-05-15-inline-build-command-path-empty.md)

## What failed

A long inline `wsl bash -lc` build bootstrap resolved the output path to an
empty string before the first `mkdir`.

## What worked

Moved the build flow into a dedicated repository script:
`scripts/build-book4edge-wsl.sh`.

## Why it worked

The script runs natively under Bash without nested quoting, so its path
variables are stable and reusable.

## All commands run

```text
wsl bash -lc '...inline build bootstrap...'
bash scripts/build-book4edge-wsl.sh
```
