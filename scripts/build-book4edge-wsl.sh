#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WSL_HOME="${HOME:?HOME must be set}"
SRC="${WSL_HOME}/book4edge-build/linux-mainline"
OUT="${WSL_HOME}/book4edge-build/out-book4edge"
ARTIFACT_DIR="${REPO_ROOT}/build-output"
PATCH_PATH="${REPO_ROOT}/patches/galaxy-book4-edge-v6.patch"
FRAGMENT_SRC="${REPO_ROOT}/configs/galaxy-book4-edge.fragment"
FRAGMENT_LOCAL="${OUT}/galaxy-book4-edge.fragment"

if [[ ! -d "${SRC}/.git" ]]; then
    echo "Kernel source tree not found at ${SRC}" >&2
    exit 1
fi

mkdir -p "${OUT}" "${ARTIFACT_DIR}"
install -m 0644 "${FRAGMENT_SRC}" "${FRAGMENT_LOCAL}"

cd "${SRC}"

if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Kernel source tree has uncommitted changes." >&2
    exit 1
fi

if ! git rev-parse --verify galaxy-book4-edge-v5 >/dev/null 2>&1; then
    echo "Expected branch galaxy-book4-edge-v5 does not exist." >&2
    exit 1
fi

git checkout galaxy-book4-edge-v5 >/dev/null

make O="${OUT}" defconfig
"${SRC}/scripts/kconfig/merge_config.sh" -O "${OUT}" \
    "${OUT}/.config" \
    "${FRAGMENT_LOCAL}"
make O="${OUT}" olddefconfig
make -j"$(nproc)" O="${OUT}" \
    Image.gz \
    dtbs

install -m 0644 "${OUT}/arch/arm64/boot/Image.gz" \
    "${ARTIFACT_DIR}/Image.gz"
install -m 0644 \
    "${OUT}/arch/arm64/boot/dts/qcom/x1e80100-samsung-galaxy-book4-edge-14.dtb" \
    "${ARTIFACT_DIR}/x1e80100-samsung-galaxy-book4-edge-14.dtb"
install -m 0644 \
    "${OUT}/arch/arm64/boot/dts/qcom/x1e84100-samsung-galaxy-book4-edge-16.dtb" \
    "${ARTIFACT_DIR}/x1e84100-samsung-galaxy-book4-edge-16.dtb"
install -m 0644 "${PATCH_PATH}" \
    "${ARTIFACT_DIR}/galaxy-book4-edge-v6.patch"

echo "Artifacts copied to ${ARTIFACT_DIR}"
