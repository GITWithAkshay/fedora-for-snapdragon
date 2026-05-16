# Solution: surface the remaining metadata blocker and prefer an elevated pass

Related problem: [2026-05-17-elevated-usb-metadata-prompt-canceled](../problems/2026-05-17-elevated-usb-metadata-prompt-canceled.md)

## Alternatives considered

1. Keep retrying non-elevated storage metadata commands.
   This repeats the same access boundary and does not change the result.
2. Auto-launch an elevated helper and rely on the user accepting the UAC
   prompt.
   This is the shortest path if the prompt is accepted, and it keeps the
   current workflow intact.
3. Use another tool such as Rufus or Fedora Media Writer to rebuild the USB.
   This can work, but it still depends on privileged device access and would
   add another layer of tool behavior to debug.
4. Move the final metadata step to another elevated Windows or Linux machine.
   This is a good fallback, but it is slower than finishing the current stick
   in place.

## What failed

The repository got the pendrive to a `FAT32` patched Fedora state, but the
attempt to stamp the remaining boot metadata through an elevated process did
not complete.

## What worked

Updated the verifier so it now reports the missing active-flag state
explicitly for `MBR` USB layouts instead of treating the stick as fully
bootable.

## Why it worked

This makes the last blocker visible and honest: the remaining gap is not the
Fedora payload anymore, it is the elevated metadata step that Windows still
has not applied.

## Commands run

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\verify-usb-bootability.ps1 `
  -UsbDriveLetter D
```
