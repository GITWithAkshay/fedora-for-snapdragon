# Solution: clear temp initrd file attributes before rewriting the appended bytes

Related problem: [2026-05-16-initrd-addon-write-access-denied](../problems/2026-05-16-initrd-addon-write-access-denied.md)

## What failed

The installer copied the backup initrd to a temporary output path on `D:`,
but the final `WriteAllBytes` call could not replace that temp file's
contents.

## What worked

Cleared the copied temp file's read-only, hidden, and system attributes
before rewriting it with the combined base-initrd and addon bytes.

## Why it worked

The temporary file no longer inherited a restrictive attribute state from the
copied source, so the installer could safely write the final concatenated
initrd content.

## Commands run

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\install-usb-boot-logging.ps1 `
  -UsbDriveLetter D
```
