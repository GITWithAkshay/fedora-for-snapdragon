# Problem: markdownlint regressed after adding build troubleshooting docs

## Exact error

<!-- markdownlint-disable MD013 -->
```text
docs/problems/2026-05-15-awk-missing-for-kconfig.md:6:81 error MD013/line-length Line length [Expected: 80; Actual: 106]
docs/problems/2026-05-15-book4-edge-patch-bitrot.md:9:81 error MD013/line-length Line length [Expected: 80; Actual: 100]
docs/problems/2026-05-15-book4-edge-usb-endpoint-labels-missing.md:6:81 error MD013/line-length Line length [Expected: 80; Actual: 155]
docs/problems/2026-05-15-dtb-target-path-duplicated.md:6:81 error MD013/line-length Line length [Expected: 80; Actual: 132]
docs/solutions/dtb-target-path-duplicated.md:53:81 error MD013/line-length Line length [Expected: 80; Actual: 190]
docs/steps.md:99:81 error MD013/line-length Line length [Expected: 80; Actual: 227]
docs/steps.md:231:81 error MD013/line-length Line length [Expected: 80; Actual: 203]
```
<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Run `npm run lint:md`.
2. Run `wsl bash -lc 'cd "/mnt/c/Users/GITWi/OneDrive/Documents/New`
   `project" && source .venv-fedora/bin/activate && bash`
   `scripts/validate.sh'`.
3. Observe line-length and blank-line failures in the new problem,
   solution, and step-log entries.

## Environment

- OS: Windows on ARM and FedoraLinux-43 on WSL2
- Validation commands: `npm run lint:md` and `bash scripts/validate.sh`
- Affected files: `docs/problems/`, `docs/solutions/`, and `docs/steps.md`

## First hypothesis

The project now needs a durable formatting strategy for long exact-error
captures and automatically appended step-log entries, because manual cleanup
alone is too easy to regress as more troubleshooting documentation is added.
