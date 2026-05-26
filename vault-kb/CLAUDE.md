# ForjarC — Knowledge Base

## Proyecto

ForjarC es un entorno Emacs modular enfocado exclusivamente en C. Derivado de FORJA, simplificado para un solo lenguaje con profundidad: herramientas de calidad, debug a nivel de instrucción, agentes IA y un sistema de aprendizaje progresivo.

- **Repo:** `~/Dev/forjarc/` (código + vault en el mismo repo)
- **Vault:** `~/Dev/forjarc/vault-kb/` ← abrir este directorio con Obsidian
- **GitHub:** https://github.com/Brianholl/ForjarC

## Estructura del vault

| Carpeta | Contenido |
|---|---|
| `ForjarC/` | Concepto, roadmap, snapshot del proyecto |
| `Infraestructura/` | Stack técnico, módulos Emacs, configuración |
| `Aprendizaje/` | Roadmap de C, mejores prácticas, herramientas, proyectos |
| `Historial/` | Logs de sesiones (CPR) |
| `INBOX/` | Notas sin clasificar |

## Convención de frontmatter

```yaml
---
title: Nombre del documento
status: activo | obsoleto | borrador
updated: YYYY-MM-DD
tags: [concepto, infraestructura, aprendizaje, herramientas, sesion]
---
```

## Convenciones de código

- **Variables, funciones:** snake_case en C; español en Elisp
- **Comentarios:** español
- **Documentación:** español

## Sesiones (CPR)

- `/resume` al iniciar — carga este CLAUDE.md + últimos logs de `Historial/`
- `/compress` al terminar — guarda log en `Historial/YYYY-MM-DD — tema.md`

## Última sesión

2026-05-25 — Creación del vault ForjarC. Se documentó el proyecto completo: concepto, roadmap, stack técnico, módulos Emacs, y base de conocimiento de aprendizaje C. Ver → [[Sesión 2026-05-25 — Creación del vault ForjarC]]
