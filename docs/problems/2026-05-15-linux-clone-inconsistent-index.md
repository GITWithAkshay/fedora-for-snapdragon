# Problem: linux source clone had an inconsistent git index state

## Exact error

```text
error: The following untracked working tree files would be overwritten by checkout:
    .clang-format
    .clippy.toml
    .cocciconfig
    .editorconfig
    ...
    Documentation/ABI/stable/sysfs-driver-w1_ds28e04
    Documentation/ABI/stable/sysfs-driver-w1_ds
Aborting
```

## Reproduction steps

1. Clone mainline Linux into `sources/linux-mainline`.
2. Clear a stale `.git/index.lock`.
3. Run `git checkout -B galaxy-book4-edge-v5`.

## Environment

- OS: FedoraLinux-43 on WSL2
- Architecture: aarch64
- Source tree: `sources/linux-mainline`
- Git operation: `checkout -B`

## First hypothesis

The earlier interrupted clone or git operation left the repository with a
working tree populated on disk but an incomplete or inconsistent index, so
git now sees tracked kernel files as untracked local content.
