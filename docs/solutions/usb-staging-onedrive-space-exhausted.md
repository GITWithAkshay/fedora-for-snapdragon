# Solution: move the large Fedora USB staging tree out of the OneDrive workspace

Related problem: [2026-05-16-usb-staging-onedrive-space-exhausted](../problems/2026-05-16-usb-staging-onedrive-space-exhausted.md)

## Alternatives considered

1. Keep staging inside the repository and hope enough local space appears.
   This is simple, but it is brittle and likely to fail again for large
   live-media images.
2. Stage in a local temp directory outside OneDrive by default.
   This avoids sync quotas and keeps the large transient payload off the repo
   path while still allowing an override.
3. Stage directly onto the USB drive without a local mirror.
   This uses less local disk, but it makes GRUB editing and repeatable
   validation harder.
4. Build a new ISO image instead of staging files.
   This is more self-contained, but it adds extra tooling and complexity we
   do not need yet for a first patched installer pass.

## What failed

The first staging run mirrored the Fedora live ISO into a directory under
the repository, which lives inside OneDrive. That path ran out of usable
space during the copy.

## What worked

Changed the default staging directory to `%TEMP%\fedora-workstation-live-book4edge`
and kept the `-StageDirectory` override for cases where we want a custom
location.

## Why it worked

The large staging tree no longer depends on the repository's OneDrive-backed
storage. We still keep the workflow reproducible, but the heavy transient
payload now lands in a better local scratch area.

## Commands run

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\prepare-patched-fedora-usb.ps1 `
  -Force
```
