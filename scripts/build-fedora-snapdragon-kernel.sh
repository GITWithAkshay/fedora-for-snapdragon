#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'EOF'
Usage:
  build-fedora-snapdragon-kernel.sh --kernel-src /path/to/linux --workspace /path/to/workspace [--dtb-name name]

Options:
  --kernel-src   Path to the Linux kernel source tree
  --workspace    Path to this workspace
  --dtb-name     Optional DTB filename to verify after build
EOF
}

KERNEL_SRC=""
WORKSPACE=""
DTB_NAME=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --kernel-src)
            KERNEL_SRC="$2"
            shift 2
            ;;
        --workspace)
            WORKSPACE="$2"
            shift 2
            ;;
        --dtb-name)
            DTB_NAME="$2"
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

if [[ -z "$KERNEL_SRC" || -z "$WORKSPACE" ]]; then
    usage
    exit 1
fi

if [[ ! -d "$KERNEL_SRC" ]]; then
    echo "Kernel source tree not found: $KERNEL_SRC" >&2
    exit 1
fi

FRAGMENT="$WORKSPACE/configs/galaxy-book4-edge.fragment"
if [[ ! -f "$FRAGMENT" ]]; then
    echo "Config fragment not found: $FRAGMENT" >&2
    exit 1
fi

export ARCH=arm64
export CROSS_COMPILE="${CROSS_COMPILE:-aarch64-linux-gnu-}"

cd "$KERNEL_SRC"

echo "Merging kernel config fragment..."
./scripts/kconfig/merge_config.sh defconfig "$FRAGMENT"
make olddefconfig

echo "Building kernel, modules, and DTBs..."
make -j"$(nproc)" Image.gz modules dtbs

echo
echo "Candidate Galaxy Book4 Edge DTBs:"
find arch/arm64/boot/dts/qcom -name '*galaxy-book4-edge*.dtb' -o -name '*book4-edge*.dtb' | sort || true

if [[ -n "$DTB_NAME" ]]; then
    DTB_PATH="$(find arch/arm64/boot/dts/qcom -name "$DTB_NAME" | head -n 1 || true)"
    if [[ -z "$DTB_PATH" ]]; then
        echo "Requested DTB was not built: $DTB_NAME" >&2
        exit 1
    fi
    echo
    echo "Verified DTB: $DTB_PATH"
fi

echo
echo "Build complete."
echo "Kernel image: $KERNEL_SRC/arch/arm64/boot/Image.gz"

