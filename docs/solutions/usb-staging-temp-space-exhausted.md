# Solution: pivot from internal-drive staging to direct patched USB creation

Related problem: [2026-05-16-usb-staging-temp-space-exhausted](../problems/2026-05-16-usb-staging-temp-space-exhausted.md)

## Alternatives considered

1. Keep trying different local staging directories on the internal drive.
   This is easy to code, but it does not solve the actual disk-space limit.
2. Use another machine with more free local disk to build the staging tree.
   This would work, but it slows down progress and breaks the direct local
   workflow we want in this repo.
3. Write the patched Fedora media directly onto the target USB disk.
   This matches the real goal, avoids the internal disk bottleneck, and uses
   the removable media's free space instead.
4. Build a fully remastered ISO image and flash that later.
   This is flexible, but it adds extra ISO authoring complexity before we
   have proven the simpler USB path.

## What failed

Even after moving the local staging destination out of OneDrive and into the
temp directory, the internal disk still did not have enough free space for a
full extracted Fedora live tree.

## What worked

Added a direct writer that prepares the removable USB disk, copies the live
media from the mounted Fedora ISO straight onto that USB volume, injects the
Book4 Edge kernel and DTBs, and rewrites the live-media label argument to
match the FAT32 partition label.

## Why it worked

The USB drive has enough space for the full live-media tree, while the
internal disk does not. Writing directly to the target media removes the
host disk from the critical path and gets us closer to an actually bootable
installer.

## Commands run

```powershell
Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='D:'"
Get-PSDrive -Name C
powershell -ExecutionPolicy Bypass `
  -File .\scripts\write-patched-fedora-usb.ps1 `
  -UsbDriveLetter D
```
