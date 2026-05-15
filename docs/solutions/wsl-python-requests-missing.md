# Solution: patch-inspection helper assumed requests was installed

Related problem:
[docs/problems/2026-05-15-wsl-python-requests-missing.md](../problems/2026-05-15-wsl-python-requests-missing.md)

## What failed

A temporary helper script tried to import the third-party `requests` module
in Fedora WSL.

## What worked

Rewrote the helper to use Python's standard-library `urllib.request`
instead.

## Why it worked

The standard library is already available in the build environment, so the
inspection helper no longer depends on an extra Python package.

## All commands run

```text
python3 - <<'PY'
from urllib.request import urlopen
...
PY
```
