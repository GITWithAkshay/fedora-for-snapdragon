# Problem: merge_config.sh could not run because awk was missing

## Exact error

<!-- markdownlint-disable MD013 -->

```text
/home/CGC/book4edge-build/linux-mainline/scripts/kconfig/merge_config.sh: line 151: awk: command not found
mv: cannot stat './.tmp.config.pz5svQQUYN.new': No such file or directory
```

<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Run `bash scripts/build-book4edge-wsl.sh`.
2. Allow `make defconfig` to complete.
3. Observe `merge_config.sh` fail when it calls `awk`.

## Environment

- OS: FedoraLinux-43 on WSL2
- Build script: `scripts/build-book4edge-wsl.sh`
- Kernel helper: `scripts/kconfig/merge_config.sh`

## First hypothesis

The Fedora WSL kernel-build dependency set is missing `awk` or the
compatible provider package, so the Kconfig merge helper cannot process the
config fragment.
