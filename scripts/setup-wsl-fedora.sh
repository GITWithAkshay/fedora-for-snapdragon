#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_PATH="$REPO_ROOT/.venv-fedora"

sudo dnf install -y \
    git \
    make \
    gcc \
    bc \
    bison \
    flex \
    openssl-devel \
    elfutils-libelf-devel \
    dwarves \
    dtc \
    ncurses-devel \
    python3-pip \
    python3-virtualenv \
    ShellCheck \
    shfmt \
    ripgrep \
    nodejs \
    npm

if [[ ! -d "$VENV_PATH" ]]; then
    python3 -m venv "$VENV_PATH"
fi

# shellcheck disable=SC1091
source "$VENV_PATH/bin/activate"
python -m pip install --upgrade pip
python -m pip install -r "$REPO_ROOT/requirements-dev.txt"

cd "$REPO_ROOT"
npm install
pre-commit install
pre-commit run --all-files
bash "$REPO_ROOT/scripts/validate.sh"

echo "Fedora WSL development environment is ready."
