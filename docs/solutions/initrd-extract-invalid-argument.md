# Solution: append a tiny initrd overlay instead of extracting the whole archive

Related problem: [2026-05-16-initrd-extract-invalid-argument](../problems/2026-05-16-initrd-extract-invalid-argument.md)

## Alternatives considered

1. Keep using `tar -xf` on the full initrd from Windows.
   This repeats the filesystem incompatibility with symlinks, device nodes,
   and special archive entries.
2. Extract and patch the initrd inside Linux or Docker.
   This could work, but it adds more moving parts and was unnecessary for a
   one-file dracut hook.
3. Append a tiny compressed cpio overlay that contains only the new hook.
   This matches how the kernel can consume concatenated initramfs archives
   and avoids the Windows extraction problem entirely.
4. Stop patching the initrd and rely only on post-boot manual logging.
   This would be simpler, but it would miss the early initrd-phase evidence
   we want during first-boot troubleshooting.

## What failed

Windows `tar.exe` could inspect the Fedora initrd, but it could not fully
extract it onto the USB-visible filesystem because that filesystem could not
represent the archive's special entries cleanly.

## What worked

Switched to building a very small `cpio.zst` addon archive that contains
only the Book4 Edge pre-pivot hook, then appended that addon to the existing
initrd backup to form the new live-media initrd.

## Why it worked

The Linux initramfs loader can process concatenated compressed cpio archives,
so the addon does not need to replace or unpack the original archive. That
made the workflow Windows-friendly while still injecting the logging hook.

## Commands run

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\install-usb-boot-logging.ps1 `
  -UsbDriveLetter D
```
