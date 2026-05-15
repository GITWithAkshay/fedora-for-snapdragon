# Solution: merge_config.sh could not handle the workspace path with spaces

Related problem:
[docs/problems/2026-05-15-merge-config-path-space.md](../problems/2026-05-15-merge-config-path-space.md)

## What failed

`merge_config.sh` split the repository path at the space in
`/mnt/c/Users/GITWi/OneDrive/Documents/New project`.

## What worked

Updated the build script to copy `configs/galaxy-book4-edge.fragment` into
the WSL output tree and merge that local copy instead.

## Why it worked

The Kconfig helper only had trouble with the path spelling, not the fragment
content, so moving the fragment to a space-free path removed the issue.

## All commands run

```text
bash scripts/build-book4edge-wsl.sh
```
