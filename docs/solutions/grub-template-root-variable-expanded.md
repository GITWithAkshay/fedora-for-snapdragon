# Solution: build the GRUB menu block from a literal template with placeholders

Related problem: [2026-05-16-grub-template-root-variable-expanded](../problems/2026-05-16-grub-template-root-variable-expanded.md)

## What failed

The custom GRUB block used a double-quoted here-string, so PowerShell tried
to interpolate the literal GRUB variable `$root`.

## What worked

Replaced the interpolated here-string with a single-quoted template that
contains placeholder tokens for the standard and basic kernel arguments, then
filled those placeholders with `.Replace(...)`.

## Why it worked

The GRUB variables now stay literal, while the dynamic kernel argument
payload still gets inserted cleanly. That keeps the output valid for both
PowerShell strict mode and GRUB.

## Commands run

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\write-patched-fedora-usb.ps1 `
  -UsbDriveLetter D
```
