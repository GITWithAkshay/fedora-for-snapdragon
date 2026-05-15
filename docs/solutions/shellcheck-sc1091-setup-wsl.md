# Solution: shellcheck SC1091 in setup-wsl-fedora.sh

Related problem:
[docs/problems/2026-05-15-shellcheck-sc1091-setup-wsl.md](../problems/2026-05-15-shellcheck-sc1091-setup-wsl.md)

## What failed

ShellCheck reported `SC1091` because the script sources a virtual
environment activation file that is created at runtime.

## What worked

Added a narrow `# shellcheck disable=SC1091` directive directly above the
`source "$VENV_PATH/bin/activate"` line.

## Why it worked

The warning was about static analysis visibility, not a runtime bug. A
line-local suppression keeps the rest of the script fully linted while
documenting that the dynamic source path is intentional.

## All commands run

```text
wsl bash -lc '
  cd "/mnt/c/Users/GITWi/OneDrive/Documents/New project" &&
  bash scripts/setup-wsl-fedora.sh
'
```
