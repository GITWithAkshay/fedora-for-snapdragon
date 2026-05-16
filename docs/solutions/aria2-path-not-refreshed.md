# Solution: discover aria2 from PATH or the winget package directory

Related problem: [2026-05-16-aria2-path-not-refreshed](../problems/2026-05-16-aria2-path-not-refreshed.md)

## What failed

Immediately after installing `aria2` with `winget`, the current PowerShell
session still could not resolve `aria2c` by name.

## What worked

Used the full `aria2c.exe` path for the first successful download, then
added repository logic that looks for `aria2c` in the current PATH and falls
back to common `winget` install locations.

## Why it worked

The package installation updated the user environment for future shells, but
the active PowerShell process had not reloaded PATH yet. Explicit discovery
avoids that timing issue and lets the downloader work immediately after the
package install.

## Commands run

```powershell
winget install --id aria2.aria2 --exact `
  --accept-package-agreements `
  --accept-source-agreements `
  --disable-interactivity
Get-Command aria2c
Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages" `
  -Filter aria2c.exe `
  -Recurse `
  -File
powershell -ExecutionPolicy Bypass -File .\scripts\download-fedora-iso.ps1
```
