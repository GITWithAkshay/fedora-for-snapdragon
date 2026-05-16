# Problem: the elevated USB metadata fix was canceled before Windows applied it

## Exact error

```text
Start-Process:
The operation was canceled by the user.
```

## Reproduction steps

1. Prepare the pendrive as `FAT32` with the patched Fedora media tree.
2. Attempt to launch an elevated PowerShell process that runs `diskpart` to
   mark the USB partition active.
3. Observe the elevated process fail to start because Windows reports the
   operation was canceled before the metadata change runs.

## Environment

- USB: `D:` (`FEDORA44`)
- Disk style: `MBR`
- Pending metadata change: active partition flag
- Launch method: `Start-Process -Verb RunAs`

## First hypothesis

The remaining blocker is the Windows elevation boundary itself. The pendrive
content is already in good shape, but the final firmware-visible metadata
change cannot be applied unless the elevated prompt is accepted.
