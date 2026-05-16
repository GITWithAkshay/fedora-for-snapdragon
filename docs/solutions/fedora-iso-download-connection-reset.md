# Solution: replace Invoke-WebRequest with aria2 for the Fedora ARM ISO

Related problem: [2026-05-16-fedora-iso-download-connection-reset](../problems/2026-05-16-fedora-iso-download-connection-reset.md)

## What failed

`Invoke-WebRequest` downloaded for several minutes and then lost the large
Fedora ISO transfer when the remote host reset the connection.

## What worked

Switched the ISO download to `aria2`, which gives us a visible progress bar,
resumable downloads, multiple connections per server, and retry behavior.

## Why it worked

`aria2` is better suited to large installer-media downloads than the default
PowerShell web client in this environment. It can resume partial work and
recover from transient mirror interruptions without forcing the whole ISO
download to restart.

## Commands run

```powershell
$isoUrl = (
  "https://download.fedoraproject.org/pub/fedora/linux/releases/44/" +
  "Workstation/aarch64/iso/Fedora-Workstation-Live-44-1.7.aarch64.iso"
)
Invoke-WebRequest `
  -Uri $isoUrl `
  -OutFile ".\downloads\Fedora-Workstation-Live-44-1.7.aarch64.iso"
powershell -ExecutionPolicy Bypass -File .\scripts\download-fedora-iso.ps1
Get-FileHash -Path .\downloads\Fedora-Workstation-Live-44-1.7.aarch64.iso `
  -Algorithm SHA256
```
