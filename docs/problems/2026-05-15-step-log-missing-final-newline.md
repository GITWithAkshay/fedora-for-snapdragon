# Problem: step logger omitted final newline in docs/steps.md

## Exact error

```text
check for merge conflicts................................................Passed
fix end of files.........................................................Failed
- hook id: end-of-file-fixer
- exit code: 1
- files were modified by this hook

Fixing docs/steps.md
```

## Reproduction steps

1. Run `powershell -ExecutionPolicy Bypass -File .\scripts\log-step.ps1 ...`.
2. Run:

   ```text
   wsl bash -lc '
     cd "/mnt/c/Users/GITWi/OneDrive/Documents/New project" &&
     bash scripts/setup-wsl-fedora.sh
   '
   ```

3. Observe `pre-commit` modify `docs/steps.md` with `end-of-file-fixer`.

## Environment

- Windows logger script writing into a shared repository
- FedoraLinux-43 WSL validation using
  `pre-commit`

## First hypothesis

The custom logger writes LF separators but does not append a final newline,
so `end-of-file-fixer` normalizes the file on every later validation pass.
