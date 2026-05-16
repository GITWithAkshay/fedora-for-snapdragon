# Solution: treat an empty USB log directory as a waiting state

Related problem: [2026-05-17-no-usb-boot-log-folders-yet](../problems/2026-05-17-no-usb-boot-log-folders-yet.md)

## What failed

Nothing in the collector itself failed. The log directory simply did not
contain any timestamped boot-attempt folders yet.

## What worked

Kept the collector behavior intentionally simple: warn clearly when no boot
logs exist yet, then stop without pretending there is data to summarize.

## Why it worked

This gives us a clean distinction between "the collector is broken" and
"there is no laptop-side boot evidence yet." That reduces false debugging
work on the Windows side.

## Commands run

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\collect-usb-boot-logs.ps1 `
  -UsbDriveLetter D
```
