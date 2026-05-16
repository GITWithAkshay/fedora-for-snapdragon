# Problem: direct USB fallback copied the live media but could not rewrite grub.cfg

## Exact error

```text
Exception calling "WriteAllText" with "3" argument(s):
"Access to the path 'D:\boot\grub2\grub.cfg' is denied."
```

## Reproduction steps

1. Keep the Fedora ISO and Book4 Edge build artifacts in place.
2. Run the direct USB writer from a non-elevated shell so it falls back to
   in-place patching on `D:`.
3. Let the script mirror the Fedora live-media tree onto the USB.
4. Observe the script fail when it tries to rewrite `D:\boot\grub2\grub.cfg`.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Target USB: `D:` (`Eshank`)
- File:
  `D:\boot\grub2\grub.cfg`

## First hypothesis

The copied Fedora media preserved attributes that block direct overwrite of
`grub.cfg` from this shell. The writer should clear restrictive attributes on
the files it needs to patch before calling `WriteAllText`.
