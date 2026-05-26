#!/bin/bash
# =============================================================================
# install.sh — forja-c — C IDE
# Uso: bash install.sh [--verify]
# =============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

ok()   { echo -e "${GREEN}[OK]${NC}  $1"; }
warn() { echo -e "${YELLOW}[!!]${NC}  $1"; }
info() { echo -e "${BLUE}[..]${NC}  $1"; }
err()  { echo -e "${RED}[XX]${NC}  $1"; exit 1; }
step() { echo -e "\n${BOLD}${CYAN}━━━ $1 ━━━${NC}"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORE_DIR="$SCRIPT_DIR/core"
AI_DIR="$SCRIPT_DIR/ai"

if [ ! -f "$CORE_DIR/install.sh" ]; then
    info "Inicializando submodules (core, ai)..."
    if ! ssh -o BatchMode=yes -o ConnectTimeout=5 -T git@github.com 2>&1 | grep -qi "successfully"; then
        info "SSH no disponible — usando HTTPS para clonar submodules..."
        git -C "$SCRIPT_DIR" config url."https://github.com/".insteadOf "git@github.com:"
    fi
    git -C "$SCRIPT_DIR" submodule update --init --recursive \
        || err "No se pudo inicializar submodules."
fi
[ -f "$CORE_DIR/install.sh" ] || err "core/install.sh no encontrado tras init — revisa el repo."

[[ "${1:-}" == "--verify" ]] && { bash "$CORE_DIR/install.sh" --verify; exit $?; }

command -v pacman &>/dev/null || err "Requiere Arch Linux."

sudo -v || err "Se necesita sudo."
( while true; do sudo -n true; sleep 240; done ) &
_SUDO_PID=$!
trap "kill $_SUDO_PID 2>/dev/null; exit" INT TERM EXIT

echo ""
echo -e "${BOLD}${CYAN}"
echo "  ███████╗ ██████╗ ██████╗      ██╗ █████╗      ██████╗"
echo "  ██╔════╝██╔═══██╗██╔══██╗     ██║██╔══██╗    ██╔════╝"
echo "  █████╗  ██║   ██║██████╔╝     ██║███████║    ██║"
echo "  ██╔══╝  ██║   ██║██╔══██╗██   ██║██╔══██║    ██║"
echo "  ██║     ╚██████╔╝██║  ██║╚█████╔╝██║  ██║    ╚██████╗"
echo "  ╚═╝      ╚═════╝ ╚═╝  ╚═╝ ╚════╝ ╚═╝  ╚═╝     ╚═════╝"
echo -e "${NC}"
echo -e "  ${BOLD}forja-c — C IDE${NC}"
echo ""

# =============================================================================
# [1] CORE
# =============================================================================
step "1 — forja-core"
export FORJA_IDE_NAME="forja-c"
export FORJA_EMACS_DIR="$SCRIPT_DIR/emacs/.emacs.d"
export FORJA_EXT_MODULES_DIR="$SCRIPT_DIR/emacs/.emacs.d/modules"
export FORJA_EXTRA_PACKAGES="cmake-mode clang-format disaster"
bash "$CORE_DIR/install.sh"

# =============================================================================
# [2] TOOLCHAIN C
# =============================================================================
step "2 — Toolchain C"
sudo pacman -S --needed --noconfirm \
    gcc clang llvm gdb make valgrind lcov \
    || warn "Algunos paquetes C fallaron"
ok "gcc, clangd, gdb, valgrind, lcov listos"

# =============================================================================
# [3] AGENTES IA (si existe el submodule ai/)
# =============================================================================
if [ -f "$AI_DIR/install.sh" ]; then
    step "3 — forja-ai"
    bash "$AI_DIR/install.sh"
else
    info "Submodule ai/ no inicializado — omitiendo agentes IA"
    info "Para instalarlos: git submodule update --init ai && bash ai/install.sh"
fi

# =============================================================================
# [4] PROYECTOS C
# =============================================================================
step "4 — Directorio de proyectos"
mkdir -p "$HOME/forja-org/local/projects/c"
ok "~/forja-org/local/projects/c/ listo"

# =============================================================================
# FISH FUNCTION
# =============================================================================
FISH_FUNC="$HOME/.config/fish/functions/forja-c.fish"
if [ ! -f "$FISH_FUNC" ]; then
    mkdir -p "$(dirname "$FISH_FUNC")"
    cat > "$FISH_FUNC" << FISH
function forja-c --description "Emacs forja-c — C IDE"
    emacs --init-directory $SCRIPT_DIR/emacs/.emacs.d/ \$argv &
    disown
end
FISH
    ok "Fish function forja-c creada"
fi

echo ""
echo -e "${BOLD}${GREEN}━━━ forja-c instalado ━━━${NC}"
echo ""
echo "  Uso:"
echo "    forja-c              → abrir forja-c"
echo "    forja-c archivo.c    → abrir archivo"
echo ""
