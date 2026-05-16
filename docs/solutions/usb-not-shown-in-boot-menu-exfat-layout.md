# Solution: verify firmware-visible USB prerequisites and flag exFAT as blocker

Related problem: [2026-05-17-usb-not-shown-in-boot-menu-exfat-layout](../problems/2026-05-17-usb-not-shown-in-boot-menu-exfat-layout.md)

## What failed

The pendrive had the patched Fedora files and the removable EFI path, but it
still did not show up in the laptop boot menu.

## What worked

Added a verifier script that checks the pendrive against common removable
UEFI boot expectations and reports the current mismatch explicitly.

## Why it worked

The problem here is not hidden anymore: we can now distinguish between
"Fedora files are present" and "firmware is likely to enumerate this USB."
On the current pendrive, the verifier points directly at the `exFAT`
filesystem as the strongest blocker.

## Commands run

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\verify-usb-bootability.ps1 `
  -UsbDriveLetter D
```
