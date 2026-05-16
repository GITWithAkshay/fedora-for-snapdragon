# Problem: writing the temporary appended initrd on the USB was denied

## Exact error

```text
Exception calling "WriteAllBytes" with "2" argument(s):
"Access to the path
'D:\book4edge-initrd-addon\initrd.with-book4edge-logging' is denied."
```

## Reproduction steps

1. Run the USB boot-logging installer after it has switched to the small
   appended-addon strategy.
2. Let it build the addon archive and copy the initrd backup into the temp
   patched-initrd path on `D:`.
3. Observe the final `WriteAllBytes` call fail when replacing that temporary
   file with the appended byte stream.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Target USB: `D:` (`Eshank`)
- Temp file:
  `D:\book4edge-initrd-addon\initrd.with-book4edge-logging`

## First hypothesis

The copied temp initrd inherited a restrictive attribute state. The
installer should clear those attributes on the temp file before rewriting it
with the combined base and addon byte stream.
