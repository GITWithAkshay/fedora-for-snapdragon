# Fedora Linux Build Kit for Samsung Galaxy Book4 Edge

This workspace gives you a practical starting point for building a Linux
kernel and the supporting files needed to boot Fedora on a Samsung Galaxy
Book4 Edge with a Qualcomm Snapdragon X platform.

The key point is that these laptops boot with UEFI firmware, but Linux
support on Snapdragon X systems still commonly relies on a board-specific
Device Tree Blob (DTB). That means we build:

- the `arm64` Linux kernel image
- the matching DTB for the Galaxy Book4 Edge
- a GRUB entry that explicitly passes the DTB to the kernel

This kit is designed to be driven from this Windows workspace through a
Fedora Linux Docker container.

## Development environment

This repository now includes a Docker-first environment setup:

- Windows host tooling for git hooks and documentation checks
- Fedora Docker tooling for kernel development and artifact production

Bootstrap scripts:

- `scripts/setup-dev-env.ps1`
- `scripts/run-book4edge-docker-build.ps1`
- `scripts/build-book4edge-docker.sh`
- `scripts/validate-docker.ps1`

Validation commands:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\run-book4edge-docker-build.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\validate-docker.ps1
```

Installer media download:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\download-fedora-iso.ps1
```

Installer media staging:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\prepare-patched-fedora-usb.ps1 `
  -Force
```

Direct USB creation:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\write-patched-fedora-usb.ps1 `
  -UsbDriveLetter D
```

## Current support picture

Mainline support for the Galaxy Book4 Edge is still evolving. The board
support work that has appeared publicly is centered around Samsung Galaxy
Book4 Edge device-tree support for Snapdragon X systems.

Your exact CPU matters:

- `X1E-80-100` and `X1E-84-100` are Snapdragon X Elite variants
- `X1P-42-100` and similar names are Snapdragon X Plus variants
- `X1-26-100` is often reported in Windows in a shorter, more confusing
  form

Do not assume an X Elite DTB will safely boot an X Plus laptop.

## Files in this workspace

- `scripts/build-fedora-snapdragon-kernel.sh`
  Builds the kernel, modules, and DTBs from a Linux kernel source tree.
- `scripts/install-dtb-grub.sh`
  Installs the selected DTB, kernel, initramfs, and a GRUB menu entry on a
  Fedora target system.
- `configs/galaxy-book4-edge.fragment`
  Minimal kernel config fragment for Snapdragon X laptop bring-up.
- `boot/grub-galaxy-book4-edge.cfg`
  Sample GRUB menu entry template.

## What you need first

On the Windows host:

- Docker Desktop with the Linux engine enabled
- PowerShell
- enough free disk space for a Linux kernel source tree and build output

The Docker builder image installs the Fedora dependencies automatically.

## Typical build flow

From Windows:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run-book4edge-docker-build.ps1
```

That launcher:

- starts Docker Desktop if needed
- builds the Fedora builder image from `docker/fedora-kernel-builder.Dockerfile`
- keeps the kernel source and build tree in Docker volumes
- applies the rebased Book4 Edge patch set
- merges `configs/galaxy-book4-edge.fragment`
- builds `Image.gz` and `dtbs`
- copies the Samsung artifacts back into `build-output/`

The Docker build context is trimmed by `.dockerignore` so the container
image does not ingest local virtual environments, docs, or build outputs.

## Downloading Fedora installer media

The repository now includes a Windows downloader that uses `aria2` for a
visible progress bar plus retry and resume behavior that worked better here
than either `Invoke-WebRequest` or `Start-BitsTransfer`.

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\download-fedora-iso.ps1
```

What it does:

- locates `aria2c` from the current PATH or the local `winget` package path
- downloads the Fedora Workstation `aarch64` live ISO into `downloads/`
- verifies the SHA256 against the expected Fedora release hash
- keeps partial downloads resumable with `aria2`

You can override the defaults with:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\download-fedora-iso.ps1 `
  -IsoUrl "https://..." `
  -OutputName "custom.iso" `
  -ExpectedSha256 "ABC123..."
```

## Preparing custom patched installer media

On this machine, the most reliable path is to write the patched installer
directly onto the target USB drive because the internal disk does not have
enough free space for a full extracted Fedora live tree.

Direct writer:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\write-patched-fedora-usb.ps1 `
  -UsbDriveLetter D
```

What it does:

- confirms the selected drive letter belongs to a removable USB disk
- reformats that USB disk as GPT with an 8 GB FAT32 boot partition when the
  shell is elevated
- copies the Fedora Workstation `aarch64` live-media tree directly from the
  mounted ISO onto the USB
- expands the Book4 Edge kernel into `boot/aarch64/loader/linux-book4edge`
- copies both Book4 Edge DTBs into `boot/dtb/qcom/`
- updates Fedora live-media boot args to use the USB label
- prepends patched GRUB entries for the 14-inch and 16-inch Book4 Edge
  variants

When the shell is elevated, the direct writer erases the selected USB disk
before recreating it. Without elevation, it falls back to patching the
existing removable filesystem in place.

Optional local staging path, if another machine has enough disk space:

Once the Fedora ISO and local Book4 Edge kernel artifacts are present, build
the patched installer staging tree with:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\prepare-patched-fedora-usb.ps1 `
  -Force
```

What it does:

- mounts the downloaded Fedora Workstation `aarch64` ISO
- copies the ISO contents into a local temp staging directory outside the
  repository by default
- expands `build-output/Image.gz` into an uncompressed installer kernel
- copies both Book4 Edge DTBs into `boot/dtb/qcom/`
- prepends custom GRUB entries for the 14-inch and 16-inch Book4 Edge
  variants while leaving the stock Fedora entries in place

The generated custom boot entries use:

- `boot/aarch64/loader/linux-book4edge`
- `boot/dtb/qcom/x1e80100-samsung-galaxy-book4-edge-14.dtb`
- `boot/dtb/qcom/x1e84100-samsung-galaxy-book4-edge-16.dtb`

To copy the staged tree onto a prepared USB volume:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-patched-fedora-usb.ps1 `
  -UsbDriveLetter D
```

That sync helper assumes the target USB is already partitioned and formatted
for UEFI boot, and it mirrors the local staging tree onto the selected drive
letter.

To stage into a custom path instead of the default temp location:

```powershell
powershell -ExecutionPolicy Bypass `
  -File .\scripts\prepare-patched-fedora-usb.ps1 `
  -StageDirectory "C:\temp\fedora-workstation-live-book4edge" `
  -Force
```

## Installing on the laptop

Copy the built kernel artifacts to the Fedora install on the laptop, then
run:

```bash
sudo bash scripts/install-dtb-grub.sh \
  --kernel-build /path/to/linux \
  --dtb arch/arm64/boot/dts/qcom/your-galaxy-book4-edge.dtb \
  --boot-root /boot
```

That script:

- installs `Image.gz`
- installs the selected DTB into `/boot/dtb/qcom/`
- generates an initramfs if needed
- writes a dedicated GRUB menu entry

## How to identify your exact model

On Windows:

```powershell
wmic computersystem get model
wmic cpu get name
```

On Linux:

```bash
cat /sys/devices/virtual/dmi/id/product_name
cat /proc/device-tree/model 2>/dev/null
lscpu
```

## Important limits

This kit does not guarantee full hardware support yet. On Snapdragon X
laptops, the following may still be partial depending on the kernel branch
and firmware available:

- display acceleration
- audio
- suspend
- webcam
- touchscreen
- battery reporting
- wireless

## Development workflow

From Windows:

```powershell
.\.venv-windows\Scripts\python -m pre_commit run --all-files
npm run lint:md
```

From Docker:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run-book4edge-docker-build.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\validate-docker.ps1
```

## Current build result

The repository now contains a successful Book4 Edge kernel build from a
patched mainline source tree in:

- `build-output/Image.gz`
- `build-output/x1e80100-samsung-galaxy-book4-edge-14.dtb`
- `build-output/x1e84100-samsung-galaxy-book4-edge-16.dtb`

The build is driven from Fedora in Docker using:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run-book4edge-docker-build.ps1
```

That launcher builds a Fedora container image, keeps the kernel source and
output tree in Docker volumes, applies the rebased Samsung Book4 Edge patch
set, merges the local Snapdragon config fragment, builds `Image.gz` and
`dtbs`, and copies the Samsung artifacts back into `build-output/`.

The validation helper confirms the Docker engine is reachable, the expected
builder image exists locally, and the four expected Book4 Edge artifacts are
present.

## Sources checked while preparing this kit

- Linux ARM64 ACPI docs:
  <https://docs.kernel.org/arch/arm64/arm-acpi.html>
- Phoronix report on Book4 Edge Linux enablement:
  <https://www.phoronix.com/news/Samsung-Galaxy-Book4-Edge-Linux>
- Recent patch discussion for initial Galaxy Book4 Edge DTS support:
  <https://www.spinics.net/lists/kernel/msg6112814.html>
