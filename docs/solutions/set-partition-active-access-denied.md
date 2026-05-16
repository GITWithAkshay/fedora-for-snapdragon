# Solution: stop relying on non-elevated partition metadata changes

Related problem: [2026-05-17-set-partition-active-access-denied](../problems/2026-05-17-set-partition-active-access-denied.md)

## What failed

Windows rejected the direct `Set-Partition ... -IsActive $true` call with
`Access denied`, leaving the rebuilt FAT32 pendrive unchanged.

## What worked

Instead of pretending the stick was fully ready, the repository now treats
the active-partition bit as an explicit bootability requirement for `MBR`
USB media and reports the missing flag clearly.

## Why it worked

This turns an invisible metadata problem into a visible, testable blocker.
We still need elevation to actually flip the bit, but we no longer lose time
debugging Linux payload files when the firmware metadata is the real gap.

## Commands run

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\verify-usb-bootability.ps1 `
  -UsbDriveLetter D
```
