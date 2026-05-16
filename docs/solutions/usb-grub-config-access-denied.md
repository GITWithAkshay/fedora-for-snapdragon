# Solution: clear copied file attributes before rewriting Fedora GRUB config

Related problem: [2026-05-16-usb-grub-config-access-denied](../problems/2026-05-16-usb-grub-config-access-denied.md)

## What failed

The non-elevated USB writer fallback mirrored the Fedora live-media tree onto
`D:`, but `WriteAllText` could not overwrite `D:\boot\grub2\grub.cfg`.

## What worked

Added a helper that clears the read-only, system, and hidden attributes on
`grub.cfg` before rewriting it, and also clears the PowerShell file object's
read-only flag when present.

## Why it worked

The mirrored Fedora media can preserve attributes that are fine for static
installer files but awkward for an in-place patching workflow. Clearing those
attributes removes the local write barrier without changing the GRUB content
logic.

## Commands run

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\write-patched-fedora-usb.ps1 `
  -UsbDriveLetter D
```
