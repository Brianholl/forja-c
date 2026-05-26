#!/bin/bash
# =============================================================================
# uninstall.sh — forja-c
# Uso: ./uninstall.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export FORJA_IDE_NAME="forja-c"
export FORJA_SCRIPT_DIR="$SCRIPT_DIR"
export FORJA_EMACS_DIR="$SCRIPT_DIR/emacs/.emacs.d"
export FORJA_LANG_SHORT="c"
export FORJA_SYSTEM_PKGS="gcc clang llvm gdb make valgrind lcov"

bash "$SCRIPT_DIR/core/uninstall.sh"
