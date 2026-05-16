# Changelog

## v0.1.8 - 2026-05-16

- Harden the USB writer's native-command handling for PowerShell strict mode.
- Add a non-elevated fallback path that patches the existing removable
  filesystem in place when `diskpart` repartitioning is unavailable.
- Document the strict-mode and `diskpart` permission blockers plus their
  resolutions.

## v0.1.7 - 2026-05-16

- Add a direct patched Fedora USB writer that prepares the removable drive,
  copies the Fedora `aarch64` live media from the downloaded ISO, injects
  the Book4 Edge kernel and DTBs, and rewrites the live-media label args for
  the FAT32 boot partition.
- Keep the earlier local staging helpers available, but pivot the documented
  main workflow toward direct-to-USB creation for low-disk-space hosts.
- Record the repeated internal-disk staging failure and the chosen direct
  USB alternative.

## v0.1.6 - 2026-05-16

- Add a staging workflow that mounts the official Fedora Workstation
  `aarch64` ISO, copies it into a local USB staging tree, injects the
  Book4 Edge kernel and DTBs, and prepends patched GRUB menu entries.
- Add a USB sync helper that copies the staged patched Fedora media onto a
  prepared removable drive without rebuilding the staging tree each time.
- Document the new custom installer-media flow built on top of the
  downloaded Fedora ISO.

## v0.1.5 - 2026-05-16

- Add an `aria2`-based Fedora ISO downloader with visible progress output,
  checksum verification, and automatic executable discovery for the current
  Windows session.
- Ignore downloaded ISO and USB staging artifacts in git so installer-media
  work does not pollute commits.
- Record the failed `Invoke-WebRequest`, `Start-BitsTransfer`, and initial
  `aria2c` PATH attempts plus the working `aria2` recovery path.

## v0.1.4 - 2026-05-16

- Add a Docker validation helper and a `.dockerignore` tuned for the
  Book4 Edge container build workflow.
- Remove the now-obsolete WSL-specific build entrypoints so Docker is the
  only active Linux build path in the repository.
- Retag the Docker builder image naming to match the current repository
  version.

## v0.1.3 - 2026-05-16

- Add a Docker-first Fedora kernel builder image and launcher for the
  Galaxy Book4 Edge workflow.
- Replace the WSL-specific build path with a reproducible Docker container
  flow that stores kernel state in Docker volumes.
- Fix the rebased Book4 Edge patch so the USB `dr_mode` nodes match current
  upstream label names before containerized builds.

## v0.1.2 - 2026-05-15

- Add a WSL-native Book4 Edge kernel build flow with a reproducible build
  script and verified output artifacts.
- Add a rebased Galaxy Book4 Edge v6 patch file and document the source
  strategy used to build against current mainline.
- Record and resolve kernel-source, patch-application, path-handling, and
  DTS integration issues encountered during the first successful build.

## v0.1.1 - 2026-05-15

- Add dual-environment bootstrap scripts for Windows and Fedora WSL.
- Add repository-local validation with pre-commit, ShellCheck, and
  markdownlint.
- Add troubleshooting records and solutions for bootstrap issues,
  including newline normalization, shellcheck setup, and Markdown lint
  scope.

## v0.1.0 - 2026-05-15

- Initialize the repository in English and add development environment
  scaffolding.
