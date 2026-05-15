# Problem: Docker validation script ignored a failed native Docker command

## Exact error

```text
Docker validation completed successfully.
Error response from daemon: No such image: galaxy-book4-edge-fedora-builder:0.1.4
```

## Reproduction steps

1. Update `scripts/validate-docker.ps1` to inspect
   `galaxy-book4-edge-fedora-builder:0.1.4`.
2. Run `powershell -ExecutionPolicy Bypass -File .\scripts\validate-docker.ps1`
   before that image has been built.
3. Observe the script still print a success message even though Docker
   reported the image was missing.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Validation script: `scripts/validate-docker.ps1`

## First hypothesis

PowerShell did not convert the failed native `docker image inspect` command
into a terminating script error, so the script needs explicit `$LASTEXITCODE`
checks around Docker CLI calls.
