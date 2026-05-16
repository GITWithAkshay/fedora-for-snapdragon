# Solution: verify an existing ISO before asking aria2 to write to it

Related problem: [2026-05-16-aria2-existing-iso-file-lock](../problems/2026-05-16-aria2-existing-iso-file-lock.md)

## What failed

The downloader always invoked `aria2`, even when the Fedora ISO already
existed locally and only needed checksum verification. That caused a
write-open attempt against a file that Windows had locked while mounted.

## What worked

Changed the downloader to hash an existing ISO first. If the hash already
matches the expected Fedora checksum, the script now reports success without
calling `aria2`. If the hash does not match, the script retries the download
with `aria2` and verifies the finished file again.

## Why it worked

The mounted ISO can still be read for hashing even though it cannot be
reopened for writing. Verifying first avoids an unnecessary download step
and makes reruns safe for a completed installer image.

## Commands run

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\download-fedora-iso.ps1
```
