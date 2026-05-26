---
title: "Roadmap — ForjarC"
status: activo
updated: 2026-05-25
tags: [roadmap, forjarc]
---

# Roadmap — ForjarC

## Visión

Un entorno Emacs que sea el mejor compañero para aprender C en profundidad: desde los fundamentos hasta código máquina, con herramientas de calidad reales y agentes IA integrados.

---

## ✅ Completado

| Componente | Qué se construyó |
|---|---|
| Repo + estructura base | Derivado de FORJA, recortado a C. GNU Stow, install.sh, update.sh |
| `early-init.el` | GC máximo al arrancar, restaura a 16 MB post-init. UI suprimida antes del frame |
| `init.el` | Cargador inteligente: fast-path (.el más nuevo → load directo, no toca org). Lazy modules con idle timer 3s |
| `00-core.org` | Paquetes base, LSP, snippets YASnippet, UI, doom-themes, ivy, projectile, vterm |
| `01-dashboard.org` | Dashboard de inicio |
| `10-git.org` | Magit, projectile, treemacs, diff-hl |
| `30-c.org` | Toolchain C completo: clangd, GDB, clang-format, clang-tidy, disaster, hydra GDB, hydra C Tools, generadores de proyecto |
| `33-aider.org` | Aider vía `uv tool install aider-chat` |
| `49-multiusuario.org` | Sistema de alumnos, sync Drive (rclone), backup USB |
| `57-opencode.org` | OpenCode TUI desde Emacs |
| `58-gemini.org` | Gemini CLI desde Emacs |
| `59-claude.org` | Claude Code desde Emacs: run, ask, explain, fix errors, generate tests |
| `99-misc.org` | PDF Tools, Org config, zoom, RAM info, ForjarC Doctor |
| Snippets C | 16 patrones de diseño GoF en C (YASnippet): Factory, Observer, Strategy, etc. |
| Proyecto `maquina` | Lab de código máquina: Makefile con targets asm-intel, objdump, gdb TUI, strace, ltrace. `.gdbinit` con Intel syntax |
| `escuela/clase-01-c` | Ejercicio introductorio (El Oráculo de Números) |
| `connect.sh.template` | Template de API keys (Anthropic, Gemini, OpenRouter) |
| `vault-kb` | Este vault: concepto, roadmap, stack técnico, módulos, aprendizaje C |

---

## 🔥 Activo — Aprendizaje C

**Objetivo:** Construir una base de conocimiento completa para aprender C con ForjarC.

| Tarea | Estado |
|---|---|
| Roadmap de aprendizaje C (fundamentos → código máquina) | ✅ |
| Mejores prácticas C | ✅ |
| Referencia de herramientas | ✅ |
| Ejercicios graduados por nivel | 🔜 |
| Clases documentadas (clase-02, clase-03…) | 🔜 |

---

## 📋 Próximo

### v2.0 — Contenido pedagógico

| Tarea | Detalle |
|---|---|
| `escuela/clase-02-c` | Punteros y memoria — ejercicio con malloc/free |
| `escuela/clase-03-c` | Estructuras y listas enlazadas |
| `escuela/clase-04-c` | Archivos: leer/escribir CSV |
| `escuela/clase-05-c` | Proyecto integrador: mini-base de datos en C |
| Docs de cada snippet GoF | Explicar cuándo usar cada patrón, con ejemplo en C |

### v2.1 — Herramientas

| Tarea | Detalle |
|---|---|
| `my/forjarc-doctor` mejorado | Detectar versión de clangd, gdb, valgrind |
| Update de `update.sh` | Pre-tangle automático post-pull |
| Integración cppcheck | Análisis estático adicional |

---

## 🗄 Diferido

| Tema | Por qué diferido |
|---|---|
| Soporte WSL2 | Arch Linux cubre el caso de uso principal |
| ESP32 / FASM | Fuera del alcance C puro por ahora |
| Módulo C++ | Deliberadamente fuera — ForjarC es solo C |
| `compile_commands.json` (Bear) | `compile_flags.txt` es suficiente para proyectos de aprendizaje |
