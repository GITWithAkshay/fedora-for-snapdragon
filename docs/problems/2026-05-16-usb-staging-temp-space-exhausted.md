# Problem: Fedora USB staging also failed in the local temp directory

## Exact error

```text
robocopy failed with exit code 9 while mirroring E: to
C:\Users\GITWi\AppData\Local\Temp\fedora-workstation-live-book4edge.
```

## Reproduction steps

1. Keep the Fedora Workstation `aarch64` ISO under `downloads/`.
2. Use the updated script version whose default staging directory is
   `%TEMP%\fedora-workstation-live-book4edge`.
3. Run
   `powershell -ExecutionPolicy Bypass -File .\scripts\prepare-patched-fedora-usb.ps1`
   with `-Force`.
4. Observe the ISO copy still fail with `ERROR 112` because the local temp
   area also does not have enough free space for a full extracted live tree.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Temp staging destination:
  `C:\Users\GITWi\AppData\Local\Temp\fedora-workstation-live-book4edge`

## First hypothesis

The machine does not currently have enough free local disk for a complete
Fedora live-media staging copy anywhere on the internal drive, so the
workflow should pivot to writing directly onto the target USB media instead
of using a local extracted mirror.
