# Problem: direct USB reformat failed because diskpart could not run to completion

## Exact error

```text
Program 'diskpart.exe' failed to run:
The operation was canceled by the user
```

## Reproduction steps

1. Keep the Fedora ISO and Book4 Edge build artifacts in place.
2. Run
   `powershell -ExecutionPolicy Bypass -File .\scripts\write-patched-fedora-usb.ps1`
   with `-UsbDriveLetter D`.
3. Observe the script reach the `diskpart` reformat stage and fail before
   the USB is repartitioned.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Target USB: `D:` (`Eshank`)
- Reformat tool: `diskpart`

## First hypothesis

Repartitioning the USB requires an elevated Windows session, and the current
shell cannot complete the `diskpart` operation. The writer should support a
non-elevated fallback path that patches the existing removable filesystem in
place when repartitioning is unavailable.
