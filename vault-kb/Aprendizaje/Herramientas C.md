---
title: "Herramientas C — Referencia"
status: activo
updated: 2026-05-25
tags: [aprendizaje, herramientas, c]
---

# Herramientas C — Referencia

Todas las herramientas disponibles en ForjarC, con ejemplos de uso desde Emacs y terminal.

---

## Compilación

### GCC

Compilador principal. Flags importantes:

| Flag | Qué hace |
|---|---|
| `-Wall -Wextra` | Activa todos los warnings importantes |
| `-Werror` | Convierte warnings en errores |
| `-g3` | Debug info completa (incluye macros) |
| `-O0` | Sin optimización (default para debug) |
| `-O2` | Optimización moderada (para benchmarks) |
| `-std=c11` | Estándar C11 |
| `-lm` | Linkear con libm (math.h) |
| `-fsanitize=address` | AddressSanitizer |
| `-fsanitize=undefined` | UndefinedBehaviorSanitizer |
| `-fprofile-arcs -ftest-coverage` | Para gcov/lcov |

### Makefile estándar de ForjarC

Los proyectos generados por `my/new-c-project` incluyen estos targets:

```bash
make build      # gcc -g3 -O0 -Wall -Wextra
make run        # build + ejecutar
make test       # correr tests Unity
make asan       # gcc -fsanitize=address,undefined
make ubsan      # gcc -fsanitize=undefined
make valgrind   # valgrind --leak-check=full --track-origins=yes
make coverage   # gcov + lcov → build/coverage/
make tidy       # clang-tidy
make format     # clang-format -i
make clean      # rm -rf build/
```

---

## LSP — clangd

clangd provee: autocompletado, goto-definition, find-references, errores en tiempo real, refactoring.

**Configuración** (`compile_flags.txt` en la raíz del proyecto):
```
-Isrc
-Wall
-Wextra
-g3
-O0
-std=c11
-lm
```

**Atajos en Emacs (lsp-mode):**

| Atajo | Acción |
|---|---|
| `M-.` | Ir a definición |
| `M-,` | Volver atrás |
| `M-?` | Ver referencias |
| `C-c l r r` | Renombrar símbolo |
| `C-c l a a` | Code actions (quick fix) |
| `C-c l = =` | Formatear buffer |
| `C-c E` | Lista de errores flycheck |

---

## Debugger — GDB

### Desde Emacs (recomendado)

```
F9          → abrir GDB con el binario compilado
F10         → next (línea siguiente)
F11         → step (entrar en función)
F8          → continue
C-c G       → hydra GDB
```

### GDB TUI

```
layout split   → fuente + assembly simultáneos
layout asm     → solo assembly
layout regs    → agregar panel de registros
Ctrl-x a       → toggle TUI on/off
Ctrl-l         → refresh pantalla (si se rompe)
```

### Comandos esenciales

```gdb
b main          # breakpoint en función main
b archivo.c:25  # breakpoint en línea 25
info b          # listar breakpoints
delete 1        # eliminar breakpoint 1
watch x         # watchpoint: parar cuando x cambia

p x             # print variable
p *ptr          # print valor apuntado
p arr[3]        # print elemento de array
p (int*)0x...   # castear e imprimir dirección
display x       # mostrar x en cada paso

bt              # backtrace (call stack)
frame 2         # cambiar al frame 2
info locals     # variables locales del frame actual
info args       # argumentos de la función actual

x/10i $rip     # 10 instrucciones desde IP actual
x/4xw $rsp     # 4 words del stack en hex
x/s 0x...      # leer string en esa dirección

disas suma      # desensamblar función suma
info registers  # todos los registros
p $rax          # valor del registro rax
```

### Comandos definidos en `.gdbinit`

```gdb
reg    → info registers
stack  → frame actual + top del stack (x/16xw $rsp)
near   → 20 instrucciones alrededor del RIP actual
```

---

## Assembly y Análisis de Binario

### disaster (desde Emacs)

```
C-c d a    → abre panel con el assembly de la función bajo el cursor
```

Muestra el mapping C ↔ instrucciones Intel inline en Emacs.

### Proyecto maquina (terminal)

```bash
cd ~/Dev/forjarc/proyectos/c/maquina
make asm-intel    # genera .s en Intel syntax (O0 y O2)
make objdump      # disassembly con fuente C intercalada
make nm           # tabla de símbolos por tamaño
make size         # tamaño de secciones .text .data .bss
make readelf      # ELF headers completo
make strace       # syscalls del programa
make ltrace       # llamadas a libc
```

### Comparar O0 vs O2

```bash
diff build/ejemplos-intel-O0.s build/ejemplos-intel-O2.s | less
```

Ver qué optimiza el compilador: eliminación de código muerto, inlining, vectorización SIMD, conversión recursivo→iterativo.

---

## Sanitizadores

### AddressSanitizer (ASan)

Detecta en runtime: buffer overflow, use-after-free, use-after-scope, double-free, memory leak.

```bash
make asan
# output si hay error:
# ==12345==ERROR: AddressSanitizer: heap-buffer-overflow
# READ of size 4 at 0x602000000010 thread T0
#     #0 0x... in mi_funcion src/main.c:42
```

### UndefinedBehaviorSanitizer (UBSan)

Detecta: integer overflow, null pointer deref, shift inválido, conversiones inválidas.

```bash
make ubsan
# output:
# src/main.c:15:5: runtime error: signed integer overflow: 2147483647 + 1
```

**Buena práctica:** Siempre combinar `-fsanitize=address,undefined` juntos.

---

## Valgrind

Más lento que ASan pero más completo en análisis de memoria. Detecta leaks aunque el programa termine "sin error".

```bash
make valgrind
# o directamente:
valgrind --leak-check=full --track-origins=yes --show-reachable=yes ./build/mi-programa
```

Output:
```
==12345== LEAK SUMMARY:
==12345==    definitely lost: 40 bytes in 1 blocks
==12345==    indirectly lost: 0 bytes in 0 blocks
```

---

## Cobertura de Código (gcov/lcov)

```bash
make coverage       # compila con profiling, corre tests
make coverage-html  # genera reporte HTML en build/coverage/
# abrir build/coverage/index.html en el navegador
```

El reporte muestra qué líneas fueron ejecutadas (verde) y cuáles no (rojo). Objetivo: ≥80% de cobertura.

---

## clang-tidy

Análisis estático: detecta bugs potenciales y malas prácticas sin ejecutar el código.

```bash
make tidy
# o desde Emacs:
C-c X l
```

Checks activos en ForjarC: `clang-analyzer-*`, `modernize-*` (C11), `bugprone-*`, `performance-*`.

---

## clang-format

Formatea el código automáticamente según el estilo del proyecto (`.clang-format`).

```bash
# Desde Emacs:
C-c F b    → formatear buffer completo

# Desde terminal:
make format    # formatea todos los .c y .h del proyecto
```

Estilo por defecto de ForjarC: basado en `LLVM` con modificaciones para 4 espacios.

---

## man / cppman

Documentación de la stdlib de C desde Emacs:

```
C-c h    → man del símbolo bajo el cursor (malloc, printf, etc.)
```

También: `man 3 malloc`, `man 3 printf` desde terminal.

---

## Resumen de atajos en Emacs

| Atajo | Herramienta | Acción |
|---|---|---|
| `F5` | GCC/Make | Compilar y ejecutar |
| `F9` | GDB | Abrir debugger |
| `F10` / `F11` | GDB | Next / Step |
| `F8` | GDB | Continue |
| `C-c G` | GDB | Hydra GDB completa |
| `C-c X` | C Tools | Hydra: test, asan, valgrind, coverage... |
| `C-c d a` | disaster | Assembly inline |
| `C-c F b` | clang-format | Formatear buffer |
| `C-c h` | man | Documentación del símbolo |
| `C-c A c` | Claude Code | Abrir asistente |
| `C-c A e` | Claude Code | Explicar/corregir errores |
| `C-c A t` | Claude Code | Generar tests Unity |
| `M-x my/forjarc-doctor` | Doctor | Verificar instalación |
| `C-c m m` | Sistema | RAM disponible |
