# Problem: Start-BitsTransfer failed with a Windows resource-loader cache error

## Exact error

```text
Start-BitsTransfer:
Line |
   2 |  … ' -Force }; Start-BitsTransfer
     |  -Source 'https://download.fedoraprojec …
     |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | The resource loader cache doesn't have loaded MUI entry. (0x80073B01)

Get-Item:
Line |
   2 |  … rch64.iso'; Get-Item
     |  'downloads\Fedora-Workstation-Live-44-1.7.aarch6 …
     |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | Cannot find path
     | 'C:\Users\GITWi\OneDrive\Documents\New project\downloads\Fedora-Workstation-Live-44-1.7.aarch64.iso'
     | because it does not exist.
```

## Reproduction steps

1. Open PowerShell in the repository root.
2. Remove any partial ISO file from `downloads\`.
3. Run `Start-BitsTransfer` against the Fedora Workstation 44 aarch64 ISO
   URL with the destination file under `downloads\`.
4. Observe BITS terminate with `0x80073B01` before the destination file is
   created.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Transfer tool: `Start-BitsTransfer`
- Destination:
  `downloads\Fedora-Workstation-Live-44-1.7.aarch64.iso`

## First hypothesis

The current Windows session has a BITS or resource-loader state problem, so
BITS is not reliable here for preparing installer media.
