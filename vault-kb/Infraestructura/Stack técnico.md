---
title: "Stack técnico — ForjarC"
status: activo
updated: 2026-05-25
tags: [infraestructura, stack]
---

# Stack técnico — ForjarC

## Decisiones principales

| Componente | Tecnología | Razón |
|---|---|---|
| Editor | Emacs 29+ (Wayland/X11) | Literate config, Org Babel, GUD/GDB integrado |
| Config style | Org Babel (`.org` → `.el`) | Documentación y código en el mismo archivo |
| Symlinks | GNU Stow | `emacs/.emacs.d` → `~/.emacs.d` en un comando |
| Compilador | GCC (principal) + Clang (análisis) | GCC para enseñar estándar; clangd para LSP |
| LSP | clangd | Entiende `compile_flags.txt` sin configuración extra |
| Debugger | GDB con TUI mode | `layout split` = fuente + assembly simultáneos |
| Build system | Makefile (proyectos de aprendizaje) + CMake (opcional) | Make muestra la compilación sin abstracción |
| Tests | Unity (C puro, single-file) | El alumno puede leer el framework completo |
| Sanitizadores | ASan + UBSan (GCC) | Detectan bugs de memoria y UB en runtime |
| Memoria | Valgrind | Memory leaks + profiling |
| Cobertura | gcov + lcov | Coverage de tests con reporte HTML |
| Análisis estático | clang-tidy | Lint integrado en LSP |
| Assembly | disaster (Emacs pkg) + objdump | Ver C → assembly inline o en buffer separado |
| IA — code agent | Aider (`uv tool install aider-chat`) | Refactoring agentico, integrado en terminal |
| IA — TUI | OpenCode, Gemini CLI, Claude Code | Tres agentes accesibles desde Emacs con atajo |
| Package manager | MELPA vía `use-package` | Estándar de Emacs moderno |
| Performance | `gc-cons-threshold=most-positive-fixnum` en early-init | ~15-20% menos tiempo de startup |
| Módulos lazy | `run-with-idle-timer 3s` para IA y multiusuario | Los agentes no bloquean el arranque |

## Estructura del repositorio

```
forjarc/
├── emacs/
│   └── .emacs.d/
│       ├── early-init.el          — GC, UI, native-comp
│       ├── init.el                — cargador inteligente de módulos
│       └── modules/
│           ├── 00-core.org        — UX, fuentes, LSP, snippets, ivy, projectile
│           ├── 01-dashboard.org   — dashboard de inicio
│           ├── 10-git.org         — Magit, treemacs, diff-hl
│           ├── 30-c.org           — todo lo de C: toolchain, GDB, hydras, generadores
│           ├── 33-aider.org       — Aider (code agent)
│           ├── 49-multiusuario.org — alumnos, Drive, USB
│           ├── 57-opencode.org    — OpenCode TUI
│           ├── 58-gemini.org      — Gemini CLI
│           ├── 59-claude.org      — Claude Code
│           └── 99-misc.org        — PDF, Org, zoom, RAM, doctor
│       └── snippets/c-mode/       — 16 patrones GoF (YASnippet)
├── escuela/
│   └── clase-01-c/                — El Oráculo de Números
├── proyectos/
│   └── c/
│       └── maquina/               — lab código máquina + assembly + GDB
├── vault-kb/                      — este vault (Obsidian)
├── install.sh                     — instalador en 12 pasos
├── update.sh                      — actualizador
├── connect.sh.template            — template de API keys
├── claude.sh                      — launcher Claude Code
├── gemini.sh                      — launcher Gemini CLI
└── opencode.sh                    — launcher OpenCode
```

## Cómo funciona el cargador de módulos

`init.el` implementa un cargador con dos caminos:

```
¿Existe NAME.el y es más nuevo que NAME.org?
  SÍ → load NAME.el directamente (org nunca se carga)   ← arranque normal
  NO → require org → tangle NAME.org → load NAME.el     ← primera vez o tras editar
```

En instalación limpia, `install.sh` pre-tanglea todos los `.org` → `.el` para que el primer arranque use el camino rápido.

## Instalación

```bash
git clone git@github.com:Brianholl/ForjarC.git ~/Dev/forjarc
cd ~/Dev/forjarc
bash install.sh
```

`install.sh` en 12 pasos:
1. Dependencias sistema (yay)
2. clangd, gcc, gdb, valgrind, lcov, stow
3. Aider vía `uv tool install aider-chat`
4. Claude Code (`npm install -g @anthropic-ai/claude-code`)
5. Gemini CLI
6. OpenCode
7. GNU Stow symlinks (`emacs/.emacs.d` → `~/.emacs.d`)
8. Bootstrap paquetes Emacs (batch mode)
9. Pre-tangle todos los `.org` → `.el`
10. Crear `connect.sh` desde template si no existe

## Agentes IA disponibles

| Agente | Atajo Emacs | Cómo abrirlo |
|---|---|---|
| Claude Code | `C-c A c` | Hydra `C-c A` → `c` |
| Gemini CLI | `C-c G g` | Hydra Gemini |
| OpenCode | `C-c O o` | Hydra OpenCode |
| Aider | `C-c i o` | Hydra Aider |

Las API keys van en `connect.sh` (gitignored). Se carga con `source ~/Dev/forjarc/connect.sh`.
