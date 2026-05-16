# Problem: the patched Fedora pendrive did not appear in the laptop boot menu

## Exact symptom

The USB drive containing the patched Fedora media tree did not appear as a
bootable option in the Samsung Galaxy Book4 Edge firmware boot menu.

## Reproduction steps

1. Prepare the `Eshank` pendrive with the patched Fedora media tree.
2. Reboot the laptop and open the firmware boot menu.
3. Look for the pendrive as a boot target.
4. Observe that the USB is not listed at all.

## Environment

- Laptop: Samsung Galaxy Book4 Edge
- USB label: `Eshank`
- Current filesystem: `exFAT`
- Current partition style from Windows: single removable installable
  filesystem partition

## First hypothesis

The USB contains the right Fedora and EFI files, but its current `exFAT`
layout is not a common UEFI removable-boot layout. Many firmwares only
enumerate removable EFI media when the boot partition is `FAT32`.
