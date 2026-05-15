# Problem: markdownlint failed a second time after the first cleanup

## Exact error

<!-- markdownlint-disable MD013 -->
```text
docs/problems/2026-05-15-markdownlint-failures.md:6:81 error MD013/line-length Line length [Expected: 80; Actual: 110]
docs/problems/2026-05-15-markdownlint-failures.md:7:81 error MD013/line-length Line length [Expected: 80; Actual: 110]
docs/problems/2026-05-15-markdownlint-failures.md:8:81 error MD013/line-length Line length [Expected: 80; Actual: 110]
docs/problems/2026-05-15-markdownlint-failures.md:9:81 error MD013/line-length Line length [Expected: 80; Actual: 163]
docs/problems/2026-05-15-markdownlint-failures.md:10:81 error MD013/line-length Line length [Expected: 80; Actual: 130]
docs/problems/2026-05-15-markdownlint-failures.md:12:81 error MD013/line-length Line length [Expected: 80; Actual: 163]
docs/problems/2026-05-15-markdownlint-failures.md:13:81 error MD013/line-length Line length [Expected: 80; Actual: 130]
docs/problems/2026-05-15-markdownlint-failures.md:15:81 error MD013/line-length Line length [Expected: 80; Actual: 164]
docs/problems/2026-05-15-markdownlint-failures.md:16:81 error MD013/line-length Line length [Expected: 80; Actual: 131]
docs/problems/2026-05-15-markdownlint-failures.md:18:81 error MD013/line-length Line length [Expected: 80; Actual: 164]
docs/problems/2026-05-15-markdownlint-failures.md:19:81 error MD013/line-length Line length [Expected: 80; Actual: 131]
docs/problems/2026-05-15-pre-commit-missing.md:12:81 error MD013/line-length Line length [Expected: 80; Actual: 105]
docs/problems/2026-05-15-step-log-crlf-reintroduced.md:15:81 error MD013/line-length Line length [Expected: 80; Actual: 125]
docs/problems/2026-05-15-step-log-crlf-reintroduced.md:19:81 error MD013/line-length Line length [Expected: 80; Actual: 111]
docs/problems/2026-05-15-step-log-crlf-reintroduced.md:20:81 error MD013/line-length Line length [Expected: 80; Actual: 155]
docs/steps.md:42 error MD012/no-multiple-blanks Multiple consecutive blank lines [Expected: 1; Actual: 2]
docs/steps.md:46:81 error MD013/line-length Line length [Expected: 80; Actual: 165]
README.md:62:81 error MD013/line-length Line length [Expected: 80; Actual: 96]
README.md:73:81 error MD013/line-length Line length [Expected: 80; Actual: 120]
Command failed: npm run lint:md
```
<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Run `powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1`.
2. Wait for `pre-commit` to pass.
3. Observe `markdownlint` fail on long lines and extra blank lines.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Node: v24.14.1
- npm: 11.11.0
- markdownlint-cli: 0.48.0

## First hypothesis

The first cleanup fixed part of the Markdown issues, but the remaining
problem files still contain long captured error lines that exceed the
default lint limit. The step log also contains an extra blank line and one
unwrapped entry.
