#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${REPO_ROOT:-/workspace}"
STATE_ROOT="${STATE_ROOT:-/state}"
SRC_ROOT="${STATE_ROOT}/src"
OUT_ROOT="${STATE_ROOT}/out"
SRC="${SRC_ROOT}/linux-mainline"
OUT="${OUT_ROOT}/book4edge"
ARTIFACT_DIR="${REPO_ROOT}/build-output"
PATCH_PATH="${REPO_ROOT}/patches/galaxy-book4-edge-v6.patch"
FRAGMENT_SRC="${REPO_ROOT}/configs/galaxy-book4-edge.fragment"
FRAGMENT_LOCAL="${OUT}/galaxy-book4-edge.fragment"
KERNEL_REMOTE="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"

mkdir -p "${SRC_ROOT}" "${OUT_ROOT}" "${ARTIFACT_DIR}"

if [[ ! -f "${PATCH_PATH}" ]]; then
    echo "Patch file not found at ${PATCH_PATH}" >&2
    exit 1
fi

if [[ ! -f "${FRAGMENT_SRC}" ]]; then
    echo "Kernel config fragment not found at ${FRAGMENT_SRC}" >&2
    exit 1
fi

if [[ ! -d "${SRC}/.git" ]]; then
    git clone --depth 1 "${KERNEL_REMOTE}" "${SRC}"
fi

git -C "${SRC}" fetch --depth 1 origin master
git -C "${SRC}" reset --hard FETCH_HEAD
git -C "${SRC}" clean -fdx

rm -rf "${OUT}"
mkdir -p "${OUT}"
install -m 0644 "${FRAGMENT_SRC}" "${FRAGMENT_LOCAL}"

git -C "${SRC}" apply --check --whitespace=nowarn "${PATCH_PATH}"
git -C "${SRC}" apply --whitespace=nowarn "${PATCH_PATH}"

cd "${SRC}"

make -C "${SRC}" O="${OUT}" defconfig
"${SRC}/scripts/kconfig/merge_config.sh" -O "${OUT}" \
    "${OUT}/.config" \
    "${FRAGMENT_LOCAL}"
make -C "${SRC}" O="${OUT}" olddefconfig
make -C "${SRC}" -j"$(nproc)" O="${OUT}" Image.gz dtbs

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

file \
    "${ARTIFACT_DIR}/Image.gz" \
    "${ARTIFACT_DIR}/x1e80100-samsung-galaxy-book4-edge-14.dtb" \
    "${ARTIFACT_DIR}/x1e84100-samsung-galaxy-book4-edge-16.dtb"

echo "Artifacts copied to ${ARTIFACT_DIR}"
