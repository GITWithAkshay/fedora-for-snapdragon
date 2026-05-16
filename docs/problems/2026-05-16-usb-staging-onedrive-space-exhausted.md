# Problem: local Fedora USB staging failed when the repository path ran out of space

## Exact error

```text
2026/05/16 23:21:11 ERROR 112 (0x00000070) Copying File E:\start_db.elf
There is not enough space on the disk.
...
robocopy failed with exit code 9 while mirroring E: to
C:\Users\GITWi\OneDrive\Documents\New project\usb-staging\fedora-workstation-live-book4edge.
```

## Reproduction steps

1. Keep the Fedora Workstation `aarch64` ISO under `downloads/`.
2. Run
   `powershell -ExecutionPolicy Bypass -File .\scripts\prepare-patched-fedora-usb.ps1`
   with `-Force`.
3. Let the script mount the ISO and start mirroring its contents into the
   default `usb-staging/` directory inside the repository.
4. Observe `robocopy` fail mid-copy with `ERROR 112` for large Fedora files.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Repository path:
  `C:\Users\GITWi\OneDrive\Documents\New project`
- ISO size: about `2.69 GB`
- Staging destination:
  `usb-staging\fedora-workstation-live-book4edge`

## First hypothesis

The repository lives inside a OneDrive-backed path, and the default staging
tree is too large for the currently available local space or sync-backed
quota there. The staging workflow should use a large local temp directory by
default instead of the repository path.
