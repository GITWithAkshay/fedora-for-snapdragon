# Solution: read native exit codes defensively under PowerShell strict mode

Related problem: [2026-05-16-direct-usb-writer-last-exit-code-unset](../problems/2026-05-16-direct-usb-writer-last-exit-code-unset.md)

## What failed

The first direct USB writer run assumed `$LASTEXITCODE` already existed,
which is not safe under `Set-StrictMode -Version Latest`.

## What worked

Updated the native-command wrappers to read `$LASTEXITCODE` through
`Get-Variable` and default to `0` when the variable is not present yet.

## Why it worked

Strict mode no longer crashes on an unset native exit variable, and the
wrapper logic still captures real exit codes when a native command has run.

## Commands run

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\write-patched-fedora-usb.ps1 `
  -UsbDriveLetter D
```
