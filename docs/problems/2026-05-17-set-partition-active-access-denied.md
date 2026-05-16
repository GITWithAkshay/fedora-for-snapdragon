# Problem: setting the FAT32 USB partition active failed with access denied

## Exact error

```text
Set-Partition:
Access denied
```

## Reproduction steps

1. Rebuild the pendrive as `FAT32`.
2. Confirm the USB is still an `MBR` removable disk and the only partition
   has `IsActive = False`.
3. Run:
   `Set-Partition -DiskNumber 1 -PartitionNumber 1 -IsActive $true`
4. Observe Windows reject the metadata change with `Access denied`.

## Environment

- USB: `D:` (`FEDORA44`)
- Disk number: `1`
- Partition style: `MBR`
- Partition type: `FAT32 XINT13`
- Current active flag: `False`

## First hypothesis

Changing the active-partition bit requires elevated storage-management
privileges in this shell, so the next step must either use an elevated path
or move to a different USB creation tool that can stamp firmware-visible disk
metadata in one pass.
