---
title: "Módulos Emacs — ForjarC"
status: activo
updated: 2026-05-25
tags: [infraestructura, modulos, emacs]
---

# Módulos Emacs — ForjarC

Cada módulo es un archivo `.org` con bloques `emacs-lisp` que se tanglea a `.el`. Se edita el `.org`, nunca el `.el` generado.

## Módulos base (carga inmediata al arrancar)

### `00-core.org` — UX y Base

El módulo más grande. Configura todo lo que no es específico de C:

- `doom-themes` (catppuccin/monokai), `doom-modeline`, `nerd-icons`
- `company` + `company-box` — autocompletado con caja flotante
- `ivy` + `counsel` + `swiper` — búsqueda y minibuffer
- `projectile` — navegación por proyectos
- `treemacs` — árbol de archivos lateral (F7)
- `flycheck` — errores en tiempo real
- `yasnippet` + `yasnippet-snippets` — snippets
- `lsp-mode` + `lsp-ui` — protocolo LSP genérico
- `multiple-cursors` — edición multi-línea
- `vterm` — terminal integrada
- `which-key` — muestra atajos disponibles
- `magit` — Git desde Emacs
- `rainbow-delimiters`, `rainbow-mode`
- `my/duplicate-line-or-region` (`C-c D`)
- `my/smart-reverse` (`C-c R`)
- `midnight` — limpieza de buffers automática

### `01-dashboard.org` — Dashboard

Pantalla de inicio con `dashboard.el`: accesos rápidos, proyectos recientes, agenda.

### `10-git.org` — Git y Navegación

- `magit` config avanzada
- `diff-hl` — indicadores de cambios en el margen
- `projectile` config
- `treemacs-projectile`
- `vterm` config

### `30-c.org` — C (el módulo principal)

Contiene todo lo específico de C:

**Toolchain:**
- `my/c-mode-setup`: estilo linux, 4 spaces, no tabs
- `my/find-and-compile` (F5): detecta `nob.c` → `build.sh` → `Makefile` → `CMake` → archivo suelto
- `clang-format` con atajo `C-c F b`
- `disaster` — C → assembly inline (`C-c d a`)

**LSP (clangd):**
- Args: `--header-insertion=never --background-index --clang-tidy --completion-style=detailed -j=4`
- `lsp-mode` activado en `c-mode-hook`

**GDB:**
- `gdb-many-windows` activado
- F9 = abrir GDB, F10 = next, F11 = step, F8 = continue
- `my/hydra-gdb` (`C-c G`): next, step, cont, finish, up/down, watch, print, reg, break, info

**Hydra C Tools (`C-c X`):**
- `t` → Unity tests (`make test`)
- `c` → Coverage (`make coverage && make coverage-html`)
- `a` → ASan (`make asan`)
- `u` → UBSan (`make ubsan`)
- `v` → Valgrind (`valgrind --leak-check=full`)
- `l` → clang-tidy
- `f` → clang-format buffer

**Generadores de proyecto (`C-c n`):**
- `my/new-c-project` → Makefile + Unity + sanitizers
- `my/new-nob-project` → nob.h (Tsoding style)
- `my/new-gamedev-project` → Raylib + C

Todos los proyectos se crean en `~/Dev/forjarc/proyectos/`.

## Módulos lazy (carga 3s después del arranque)

### `33-aider.org` — Aider

Integración con Aider (`uv tool install aider-chat`). Atajos `C-c i`.

### `49-multiusuario.org` — Multiusuario

Sistema para entornos educativos: múltiples alumnos, backup USB, sync Drive. Atajos `C-c U`.

### `57-opencode.org` — OpenCode

Lanzador de OpenCode TUI en Alacritty. Atajo `C-c O o`.

### `58-gemini.org` — Gemini CLI

Lanzador de Gemini CLI. Atajo `C-c G g`.

### `59-claude.org` — Claude Code

Integración con Claude Code:
- `C-c A c` — abrir Claude TUI
- `C-c A e` — corregir errores de compilación con Claude
- `C-c A t` — generar tests Unity para el archivo actual
- `C-c A x` — explicar función C seleccionada
- `C-c A r` — pedir refactoring de una región

### `99-misc.org` — Misceláneos

- `pdf-tools` — lector PDF para manuales C/ISA
- Org mode config (bullets, indent, toc-org)
- `C-+` / `C--` / `C-0` — zoom
- `C-c m m` — RAM del sistema
- `M-x my/forjarc-doctor` — diagnóstico de instalación

## Snippets C (YASnippet)

16 patrones de diseño GoF implementados en C:

| Snippet | Patrón |
|---|---|
| `abstractfactory` | Abstract Factory |
| `adapter` | Adapter |
| `bridge` | Bridge |
| `builder` | Builder |
| `chainofresponsibility` | Chain of Responsibility |
| `command` | Command |
| `composite` | Composite |
| `decorator` | Decorator |
| `facade` | Facade |
| `factorymethod` | Factory Method |
| `flyweight` | Flyweight |
| `iterator` | Iterator |
| `mediator` | Mediator |
| `memento` | Memento |
| `observer` | Observer |
| `prototype` | Prototype |
| `proxy` | Proxy |
| `singleton` | Singleton |
| `state` | State |
| `strategy` | Strategy |
| `templatemethod` | Template Method |
| `visitor` | Visitor |

Activar con TAB en un buffer C.
