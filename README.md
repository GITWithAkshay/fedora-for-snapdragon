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

This kit is designed to be run on a Fedora Linux build machine, not directly
from this Windows workspace.

## Development environment

This repository now includes a dual-environment setup:

- Windows host tooling for git hooks and documentation checks
- Fedora WSL tooling for kernel development, shell linting, and package
  installation

Bootstrap scripts:

- `scripts/setup-dev-env.ps1`
- `scripts/setup-wsl-fedora.sh`
- `scripts/build-book4edge-wsl.sh`

Validation commands:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1
```

```bash
bash scripts/setup-wsl-fedora.sh
bash scripts/validate.sh
bash scripts/build-book4edge-wsl.sh
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

On a Fedora build system:

```bash
sudo dnf install -y git make gcc bc bison flex openssl-devel \
  elfutils-libelf-devel dwarves dtc ncurses-devel grub2-tools
sudo dnf install -y gcc-aarch64-linux-gnu
```

Then clone a recent kernel tree:

```bash
git clone https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
cd linux
```

If your exact laptop support is not yet in Linus's tree, use a branch that
contains the Samsung Galaxy Book4 Edge patches or apply those patches
manually before building.

## Typical build flow

From inside the kernel source tree:

```bash
cp /path/to/this/workspace/configs/galaxy-book4-edge.fragment .
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- ./scripts/kconfig/merge_config.sh \
  defconfig galaxy-book4-edge.fragment
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make olddefconfig
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make -j"$(nproc)" \
  Image.gz modules dtbs
```

Then identify the DTB that was actually produced:

```bash
find arch/arm64/boot/dts/qcom -name '*galaxy-book4-edge*.dtb' \
  -o -name '*book4-edge*.dtb'
```

Common candidates may include names like:

```text
x1e80100-samsung-galaxy-book4-edge.dtb
x1p42100-samsung-galaxy-book4-edge.dtb
```

The exact name depends on the kernel branch and patch set.

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

From Fedora WSL:

```bash
source .venv-fedora/bin/activate
pre-commit run --all-files
bash scripts/validate.sh
bash scripts/build-book4edge-wsl.sh
```

## Current build result

The repository now contains a successful Book4 Edge kernel build from a
patched mainline source tree in:

- `build-output/Image.gz`
- `build-output/x1e80100-samsung-galaxy-book4-edge-14.dtb`
- `build-output/x1e84100-samsung-galaxy-book4-edge-16.dtb`

The build is driven from Fedora WSL using:

```bash
bash scripts/build-book4edge-wsl.sh
```

That script uses a clean mainline clone on the WSL ext4 filesystem,
applies the rebased Samsung Book4 Edge patch set, merges the local
Snapdragon config fragment, builds `Image.gz` and `dtbs`, and copies the
Samsung artifacts back into `build-output/`.

## Sources checked while preparing this kit

- Linux ARM64 ACPI docs:
  <https://docs.kernel.org/arch/arm64/arm-acpi.html>
- Phoronix report on Book4 Edge Linux enablement:
  <https://www.phoronix.com/news/Samsung-Galaxy-Book4-Edge-Linux>
- Recent patch discussion for initial Galaxy Book4 Edge DTS support:
  <https://www.spinics.net/lists/kernel/msg6112814.html>
