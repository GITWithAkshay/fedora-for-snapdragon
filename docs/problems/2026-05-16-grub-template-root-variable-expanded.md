# Problem: PowerShell expanded the GRUB `$root` variable in the menu block

## Exact error

```text
The variable '$root' cannot be retrieved because it has not been set.
```

## Reproduction steps

1. Run the direct USB writer until it reaches the custom GRUB entry
   generation stage.
2. Let the script call `New-CustomGrubBlock`.
3. Observe PowerShell try to expand the literal GRUB variable `$root`
   inside the here-string and fail under strict mode.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Script:
  `scripts\write-patched-fedora-usb.ps1`

## First hypothesis

The custom GRUB block uses a double-quoted here-string, so PowerShell still
interpolates `$root`. The script needs literal escaping that survives
PowerShell parsing while still emitting valid GRUB syntax.
