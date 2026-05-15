# Problem: git commit hook could not find pre-commit

## Exact error

```text
`pre-commit` not found.  Did you forget to activate your virtualenv?
```

## Reproduction steps

1. Run `git add -A`.
2. Run `git status --short`.
3. Run `git commit -m "chore: set up dual-environment development tooling v0.1.1"`.

## Environment

- OS: Windows on ARM
- Git: `C:\Program Files\Git\cmd\git.exe`
- Repository hook installed by: `pre-commit install`

## First hypothesis

The Git hook was installed in a way that expects `pre-commit` on `PATH`,
but the repository uses a local virtual environment and the command is not
globally available to the shell that runs `git commit`.
