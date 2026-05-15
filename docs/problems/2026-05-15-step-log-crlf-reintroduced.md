# Problem: step logger reintroduced CRLF into docs/steps.md

## Exact error

<!-- markdownlint-disable MD013 -->
```text
check for merge conflicts................................................Passed
fix end of files.........................................................Passed
mixed line ending........................................................Failed
- hook id: mixed-line-ending
- exit code: 1

docs/steps.md: fixed mixed line endings

trim trailing whitespace.................................................Passed
Command failed: C:\Users\GITWi\OneDrive\Documents\New project\.venv-windows\Scripts\\python.exe -m pre_commit run --all-files
At C:\Users\GITWi\OneDrive\Documents\New project\scripts\setup-dev-env.ps1:15 char:9
+         throw "Command failed: $FilePath $($Arguments -join ' ')"
+         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : OperationStopped: (Command failed:...run --all-files:String) [], RuntimeException
    + FullyQualifiedErrorId : Command failed: C:\Users\GITWi\OneDrive\Documents\New project\.venv-windows\Scripts\\python.exe -m pre_commit run --all-files
```
<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Run `powershell -ExecutionPolicy Bypass -File .\scripts\log-step.ps1 ...`.
2. Run `powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1`.
3. Observe the `mixed-line-ending` hook fail on `docs/steps.md`.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Logger script: `scripts/log-step.ps1`
- Validation hook: `mixed-line-ending` from `pre-commit-hooks`

## First hypothesis

`Add-Content` is appending lines using Windows-native CRLF endings, which
conflicts with the repository LF policy and causes `pre-commit` to rewrite
`docs/steps.md` on every run.
