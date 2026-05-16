# Solution: stop using Start-BitsTransfer for this ISO download path

Related problem: [2026-05-16-bits-transfer-mui-cache](../problems/2026-05-16-bits-transfer-mui-cache.md)

## What failed

`Start-BitsTransfer` failed immediately with `0x80073B01` and never created
the destination ISO file.

## What worked

Dropped BITS from the installer-media workflow and moved the Fedora ISO
download to `aria2`.

## Why it worked

The issue was not with the Fedora URL but with the current Windows BITS or
resource-loader state. `aria2` avoids that subsystem entirely, gives better
user feedback through a progress bar, and proved stable enough to complete
the full ISO transfer.

## Commands run

```powershell
$isoUrl = (
  "https://download.fedoraproject.org/pub/fedora/linux/releases/44/" +
  "Workstation/aarch64/iso/Fedora-Workstation-Live-44-1.7.aarch64.iso"
)
Start-BitsTransfer `
  -Source $isoUrl `
  -Destination ".\downloads\Fedora-Workstation-Live-44-1.7.aarch64.iso"
powershell -ExecutionPolicy Bypass -File .\scripts\download-fedora-iso.ps1
```
