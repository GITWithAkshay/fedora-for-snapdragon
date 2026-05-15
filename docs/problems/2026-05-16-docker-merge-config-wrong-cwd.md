# Problem: Docker build called merge_config.sh from the wrong directory

## Exact error

```text
/workspace/patches/galaxy-book4-edge-v6.patch:1614: new blank line at EOF.
+
warning: 1 line adds whitespace errors.
make: *** No rule to make target 'alldefconfig'.  Stop.
```

## Reproduction steps

1. Start Docker Desktop and verify `docker version` succeeds.
2. Run `powershell -ExecutionPolicy Bypass -File`
   `.\scripts\run-book4edge-docker-build.ps1`.
3. Let the Fedora container reach the config merge stage.
4. Observe `merge_config.sh` end with
   `make: *** No rule to make target 'alldefconfig'.  Stop.`

## Environment

- OS: Windows on ARM with Docker Desktop Linux engine
- Builder image: `galaxy-book4-edge-fedora-builder:0.1.3`
- Container script: `scripts/build-book4edge-docker.sh`

## First hypothesis

The container script invoked `scripts/kconfig/merge_config.sh` without
first changing into the kernel source tree, so the helper tried to run its
follow-up `make` target from a directory that does not expose the kernel
top-level Makefile.
