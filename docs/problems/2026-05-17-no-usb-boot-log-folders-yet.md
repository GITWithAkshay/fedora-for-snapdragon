# Problem: no boot-attempt folders were present under the USB log directory yet

## Exact symptom

The post-boot log collector reported:

```text
WARNING: No boot-attempt folders were found under D:\book4edge-logs yet.
```

## Reproduction steps

1. Prepare the pendrive with the diagnostics layer.
2. Reinsert the pendrive into Windows before any successful live-session boot
   has written log artifacts back.
3. Run
   `powershell -ExecutionPolicy Bypass -File .\scripts\collect-usb-boot-logs.ps1`
   with `-UsbDriveLetter D`.
4. Observe the collector warn that no timestamped log folders exist yet.

## Environment

- USB: `D:` (`FEDORA44`)
- Log root:
  `D:\book4edge-logs`

## First hypothesis

The collector is working as intended, but the laptop has not yet completed a
boot attempt far enough for the live system or initrd hook to write a log
bundle onto the pendrive.
