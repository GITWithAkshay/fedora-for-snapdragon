# Solution: add a non-elevated direct USB fallback when repartitioning is unavailable

Related problem: [2026-05-16-diskpart-usb-reformat-canceled](../problems/2026-05-16-diskpart-usb-reformat-canceled.md)

## Alternatives considered

1. Require the whole workflow to stop until an elevated shell is available.
   This is the cleanest path for repartitioning, but it blocks progress in
   the current session.
2. Keep retrying `diskpart` from the same non-elevated shell.
   This repeats the same failure mode without changing the permissions
   constraint.
3. Fall back to patching the existing removable filesystem in place.
   This keeps progress moving without elevation, though UEFI compatibility
   may be weaker than a dedicated FAT32 boot partition.
4. Move USB creation into another tool such as Rufus.
   This could work later, but it moves the workflow outside the repository
   automation we are building.

## What failed

The direct writer reached the `diskpart` stage, but repartitioning could not
complete in the current shell.

## What worked

Added a fallback path that skips repartitioning when the shell is not
elevated and mirrors the patched Fedora live-media tree directly onto the
existing removable drive.

## Why it worked

The fallback avoids the privilege boundary while still using the available
61 GB USB space for the actual installer payload. It is not as ideal as a
fresh FAT32 GPT boot partition, but it keeps the workflow moving and leaves
the elevated reformat path available for later.

## Commands run

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\write-patched-fedora-usb.ps1 `
  -UsbDriveLetter D
```
