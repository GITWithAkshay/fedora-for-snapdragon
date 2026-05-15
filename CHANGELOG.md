# Changelog

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
