---
title: "ForjarC — Concepto"
status: activo
updated: 2026-05-25
tags: [concepto, forjarc]
---

# ForjarC — Concepto

## ¿Qué es?

ForjarC es una configuración modular de Emacs enfocada **exclusivamente en C**. Es la versión derivada de FORJA, recortada a un solo lenguaje pero con mayor profundidad: desde la escritura y el formateo hasta el debug a nivel de instrucción de máquina.

## Motivación

C es el lenguaje que más enseña. No hay runtime que oculte lo que pasa: el programador ve la memoria, los punteros, el stack, el assembly que genera cada función. Aprender C correctamente es aprender cómo funcionan las computadoras.

ForjarC existe para tener un entorno que acompañe ese aprendizaje sin fricciones: compilar con F5, debuggear con GDB integrado, ver el assembly de una función con un atajo, consultar errores con IA, y crear proyectos nuevos con plantillas listas.

## Diferencias con FORJA

| Aspecto | FORJA | ForjarC |
|---------|-------|---------|
| Lenguajes | C, C++, Rust, Go, Python, PHP, JS/TS, Lua, Zig | Solo C |
| Plataformas | Arch Linux, Termux, WSL2 | Solo Arch Linux |
| Instalador | `forja-menu.sh` (TUI interactivo, perfiles) | `install.sh` (lineal, sin perfiles) |
| Módulos | 21 módulos `.org` | 10 módulos `.org` |
| Foco | Full Stack + Game Dev + Sistemas | C: aprendizaje, calidad, código máquina |
| Agentes IA | Aider + OpenCode + PicoClaw + OpenClaw | Aider + OpenCode + Gemini + Claude |

## Público objetivo

- Estudiantes aprendiendo C por primera vez
- Programadores que quieren entender C en profundidad (punteros, memoria, assembly)
- Docentes que usan Emacs como entorno de enseñanza

## Propuesta de valor

1. **Cero configuración post-install** — `install.sh` deja todo listo: LSP, GDB, formateo, IA
2. **Aprendizaje progresivo** — desde `Hello, world` hasta código máquina e Intel assembly
3. **Herramientas de calidad reales** — ASan, UBSan, Valgrind, lcov, clang-tidy desde el día 1
4. **IA integrada** — cuatro agentes (Claude, Gemini, OpenCode, Aider) disponibles desde Emacs
5. **Proyectos de práctica** — generadores de scaffold (C genérico, nob.h, Raylib/gamedev)
