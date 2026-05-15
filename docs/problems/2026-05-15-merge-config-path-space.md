# Problem: merge_config.sh split the workspace path at spaces

## Exact error

```text
Using /home/CGC/book4edge-build/out-book4edge/.config as base
Merging /mnt/c/Users/GITWi/OneDrive/Documents/New
The merge file '/mnt/c/Users/GITWi/OneDrive/Documents/New' does not exist.  Exit.
```

## Reproduction steps

1. Run `bash scripts/build-book4edge-wsl.sh` from the repository root.
2. Let the script invoke `scripts/kconfig/merge_config.sh`.
3. Observe the merge script truncate the repository path at the first space.

## Environment

- OS: FedoraLinux-43 on WSL2
- Build script: `scripts/build-book4edge-wsl.sh`
- Workspace path: `/mnt/c/Users/GITWi/OneDrive/Documents/New project`

## First hypothesis

`merge_config.sh` is not safely handling the repository path that contains a
space, so the config fragment argument is being split before the script uses
it.
