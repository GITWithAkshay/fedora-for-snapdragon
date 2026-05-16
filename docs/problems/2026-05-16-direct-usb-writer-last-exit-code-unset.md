# Problem: direct USB writer failed before running because `$LASTEXITCODE` was unset

## Exact error

```text
C:\Users\GITWi\OneDrive\Documents\New project\
scripts\write-patched-fedora-usb.ps1 :
The variable '$LASTEXITCODE' cannot be retrieved because it has not been
set.
```

## Reproduction steps

1. Keep the Fedora ISO and Book4 Edge build artifacts in place.
2. Run
   `powershell -ExecutionPolicy Bypass -File .\scripts\write-patched-fedora-usb.ps1`
   with `-UsbDriveLetter D`.
3. Observe the script fail immediately under `Set-StrictMode -Version Latest`
   before modifying the USB drive.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Target USB: `D:` (`Eshank`)
- Script:
  `scripts\write-patched-fedora-usb.ps1`

## First hypothesis

One of the native-command wrappers assumes `$LASTEXITCODE` always exists, but
under strict mode that variable is undefined until a native command has
actually set it. The script should read it defensively with a default.
