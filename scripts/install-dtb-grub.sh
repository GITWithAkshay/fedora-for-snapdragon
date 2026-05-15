#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'EOF'
Usage:
  install-dtb-grub.sh --kernel-build /path/to/linux --dtb /path/to/file.dtb [--boot-root /boot] [--root-uuid UUID]
EOF
}

KERNEL_BUILD=""
DTB=""
BOOT_ROOT="/boot"
ROOT_UUID=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --kernel-build)
            KERNEL_BUILD="$2"
            shift 2
            ;;
        --dtb)
            DTB="$2"
            shift 2
            ;;
        --boot-root)
            BOOT_ROOT="$2"
            shift 2
            ;;
        --root-uuid)
            ROOT_UUID="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage
            exit 1
            ;;
    esac
done

if [[ -z "$KERNEL_BUILD" || -z "$DTB" ]]; then
    usage
    exit 1
fi

IMAGE="$KERNEL_BUILD/arch/arm64/boot/Image.gz"
if [[ ! -f "$IMAGE" ]]; then
    echo "Kernel image not found: $IMAGE" >&2
    exit 1
fi

if [[ ! -f "$DTB" ]]; then
    echo "DTB not found: $DTB" >&2
    exit 1
fi

KVER="$(make -s -C "$KERNEL_BUILD" kernelrelease)"
BOOT_IMAGE="$BOOT_ROOT/vmlinuz-$KVER"
INITRAMFS="$BOOT_ROOT/initramfs-$KVER.img"
DTB_DIR="$BOOT_ROOT/dtb/qcom"
DTB_BASENAME="$(basename "$DTB")"
GRUB_SNIPPET="/etc/grub.d/09_galaxy_book4_edge"

if [[ -z "$ROOT_UUID" ]] && command -v findmnt >/dev/null 2>&1; then
    ROOT_UUID="$(findmnt -no UUID / || true)"
fi

if [[ -z "$ROOT_UUID" ]]; then
    ROOT_UUID="REPLACE_WITH_ROOT_UUID"
fi

make -C "$KERNEL_BUILD" modules_install
if command -v depmod >/dev/null 2>&1; then
    depmod "$KVER"
fi

install -D -m 0644 "$IMAGE" "$BOOT_IMAGE"
install -d "$DTB_DIR"
install -m 0644 "$DTB" "$DTB_DIR/$DTB_BASENAME"

if command -v dracut >/dev/null 2>&1; then
    dracut -f "$INITRAMFS" "$KVER"
fi

cat > "$GRUB_SNIPPET" <<EOF
#!/bin/sh
cat <<'GRUBEOF'
menuentry 'Fedora Linux (Galaxy Book4 Edge DTB)' {
    linux $BOOT_IMAGE root=UUID=$ROOT_UUID rw clk_ignore_unused pd_ignore_unused
    initrd $INITRAMFS
    devicetree $DTB_DIR/$DTB_BASENAME
}
GRUBEOF
EOF

chmod 0755 "$GRUB_SNIPPET"

if [[ -d /boot/grub2 ]]; then
    grub2-mkconfig -o /boot/grub2/grub.cfg
elif [[ -d /boot/efi/EFI/fedora ]]; then
    grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
else
    echo "GRUB config directory not found. Update GRUB manually." >&2
fi

echo "Installed kernel: $BOOT_IMAGE"
echo "Installed DTB: $DTB_DIR/$DTB_BASENAME"
echo "Root UUID used in GRUB entry: $ROOT_UUID"
