# Solution: inconsistent linux clone under /mnt/c

Related problem:
[docs/problems/2026-05-15-linux-clone-inconsistent-index.md](../problems/2026-05-15-linux-clone-inconsistent-index.md)

## What failed

The first kernel clone under `/mnt/c/.../sources/linux-mainline` ended up in
an inconsistent state where ordinary tracked kernel files appeared as
conflicting local content during checkout.

## What worked

Stopped using that clone for the build and created a fresh mainline clone on
the Fedora WSL ext4 filesystem at `~/book4edge-build/linux-mainline`.

## Why it worked

The WSL ext4 filesystem is a much safer place for a large kernel git tree
and out-of-tree build than a Windows-mounted path, especially after an
interrupted clone.

## All commands run

<!-- markdownlint-disable MD013 -->
```text
git status --short
du -sh /mnt/c/Users/GITWi/OneDrive/Documents/New project/sources/linux-mainline
git clone --depth 1 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git ~/book4edge-build/linux-mainline
```
<!-- markdownlint-enable MD013 -->
