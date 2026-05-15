# Problem: solution documents contained extra blank lines

## Exact error

<!-- markdownlint-disable MD013 -->
```text
docs/solutions/pre-commit-missing.md:29 error MD012/no-multiple-blanks Multiple consecutive blank lines [Expected: 1; Actual: 2]
docs/solutions/step-log-crlf-reintroduced.md:40 error MD012/no-multiple-blanks Multiple consecutive blank lines [Expected: 1; Actual: 2]
Command failed: npm run lint:md
```
<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Run `powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1`.
2. Wait for `pre-commit` to pass.
3. Observe `markdownlint` fail on `MD012` in solution files.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- markdownlint-cli: 0.48.0

## First hypothesis

The new solution files end with an extra blank line after the closing code
fence, which violates `MD012`.
