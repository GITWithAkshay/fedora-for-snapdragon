# Solution: enter the kernel source tree before running merge_config.sh

Related problem:
[docs/problems/2026-05-16-docker-merge-config-wrong-cwd.md](../problems/2026-05-16-docker-merge-config-wrong-cwd.md)

## What failed

The first Docker build reached the config merge step and then ended with:

```text
make: *** No rule to make target 'alldefconfig'.  Stop.
```

## What worked

Updated `scripts/build-book4edge-docker.sh` so it changes into the kernel
source tree before invoking `scripts/kconfig/merge_config.sh`, then reran
the full Docker build successfully.

## Why it worked

`merge_config.sh` expects to run from a directory where the kernel
top-level `Makefile` is reachable for its follow-up config target. Entering
the source tree restored that assumption.

## All commands run

```text
powershell -ExecutionPolicy Bypass -File .\scripts\run-book4edge-docker-build.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\run-book4edge-docker-build.ps1
```
