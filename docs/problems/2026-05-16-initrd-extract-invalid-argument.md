# Problem: Windows tar could not extract the Fedora initrd onto the USB filesystem

## Exact error

```text
tar.exe: Error exit delayed from previous errors.
Failed to extract archive D:\boot\aarch64\loader\initrd.
```

Representative preceding errors included:

```text
bin: Can't create '\\?\D:\book4edge-initrd-work\extract\bin':
Invalid argument
etc/systemd/system/dbus.service: Can't create
'\\?\D:\book4edge-initrd-work\extract\etc\systemd\system\dbus.service':
Invalid argument
usr/bin/sh: Can't create
'\\?\D:\book4edge-initrd-work\extract\usr\bin\sh': Invalid argument
```

## Reproduction steps

1. Run the USB boot-logging installer against `D:`.
2. Let it copy or reference the existing Fedora live initrd.
3. Attempt a full `tar -xf` extraction of the initrd onto a directory on the
   USB drive.
4. Observe `tar.exe` fail on symlinks, device nodes, and other initrd entries
   that the target Windows-visible filesystem cannot represent.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Tool: `tar.exe` / bsdtar
- Target filesystem: removable USB media at `D:`

## First hypothesis

We do not need a full initrd extraction to add one small dracut hook. A tiny
overlay cpio archive appended to the existing initrd should be a safer fit
for Windows and for the kernel's initramfs loader.
