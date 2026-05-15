# Solution: missing awk for merge_config.sh

Related problem:
[docs/problems/2026-05-15-awk-missing-for-kconfig.md](../problems/2026-05-15-awk-missing-for-kconfig.md)

## What failed

The Kconfig merge helper could not run because `awk` was not available in
Fedora WSL.

## What worked

Installed `gawk` through `dnf`.

## Why it worked

`merge_config.sh` relies on `awk`, and Fedora provides that functionality
through the `gawk` package.

## All commands run

```text
sudo dnf install -y gawk
```
