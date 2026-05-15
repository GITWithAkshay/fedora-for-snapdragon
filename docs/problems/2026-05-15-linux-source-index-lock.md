# Problem: stale git index.lock blocked patch application in linux source tree

## Exact error

<!-- markdownlint-disable MD013 -->

```text
fatal: Unable to create '/mnt/c/Users/GITWi/OneDrive/Documents/New project/sources/linux-mainline/.git/index.lock': File exists.

Another git process seems to be running in this repository, e.g.
an editor opened by 'git commit'. Please make sure all processes
are terminated then try again. If it still fails, a git process
may have crashed in this repository earlier:
remove the file manually to continue.
```

<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Change into `sources/linux-mainline` under Fedora WSL.
2. Run `git checkout -B galaxy-book4-edge-v5`.
3. Attempt `git am` with the Galaxy Book4 Edge patch mailbox.

## Environment

- OS: FedoraLinux-43 on WSL2
- Architecture: aarch64
- Source tree: `sources/linux-mainline`
- Branch target: `galaxy-book4-edge-v5`

## First hypothesis

An earlier interrupted git operation left behind `.git/index.lock`, so git
is refusing to mutate the tree until the stale lock is removed.
