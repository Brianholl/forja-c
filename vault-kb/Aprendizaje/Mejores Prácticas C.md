---
title: "Mejores Prácticas C"
status: activo
updated: 2026-05-25
tags: [aprendizaje, c, practicas]
---

# Mejores Prácticas C

Principios concretos para escribir C correcto, seguro y legible. Cada regla tiene una razón.

---

## Organización del código

### Separar declaración de definición

```c
// suma.h — declaración (lo que el mundo ve)
#ifndef SUMA_H
#define SUMA_H
int suma(int a, int b);
#endif

// suma.c — definición (la implementación)
#include "suma.h"
int suma(int a, int b) { return a + b; }

// main.c — uso
#include "suma.h"
```

**Por qué:** Los include guards (`#ifndef`) evitan que el header se procese dos veces. Sin ellos, redefinición de tipos = error de compilación.

### Visibilidad mínima

```c
// Si una función solo se usa en suma.c, declararla static:
static int helper(int x) { return x * 2; }
```

`static` en funciones y variables globales = "privado para este archivo". El linker no lo ve desde afuera.

### Un concepto por archivo

- `lista.h` / `lista.c` — solo la lista enlazada
- `parser.h` / `parser.c` — solo el parser
- `main.c` — solo el punto de entrada y la orquestación

---

## Gestión de memoria

### La regla del propietario

Quien aloca, libera. Documentar quién es el dueño:

```c
// malloc devuelve memoria que el LLAMADOR debe liberar
char *leer_archivo(const char *path) {
    // el llamador es dueño del resultado
    return malloc(tamanio);
}
```

### Siempre verificar malloc

```c
// INCORRECTO:
int *arr = malloc(n * sizeof(int));
arr[0] = 1;  // UB si malloc devolvió NULL

// CORRECTO:
int *arr = malloc(n * sizeof(int));
if (arr == NULL) {
    perror("malloc");
    exit(EXIT_FAILURE);
}
```

### Poner a NULL después de free

```c
free(ptr);
ptr = NULL;  // próximo uso detectará el NULL antes de crashear
```

### Preferir stack al heap cuando el tamaño se conoce

```c
// Si n es fijo y pequeño, mejor stack:
char buffer[256];

// Solo ir a heap si el tamaño es dinámico o grande:
char *buf = malloc(n);
```

---

## Errores y manejo de errores

### Verificar el valor de retorno de funciones del sistema

```c
FILE *f = fopen("datos.txt", "r");
if (f == NULL) {
    perror("No se pudo abrir datos.txt");
    return -1;
}
```

`perror` imprime el error del sistema operativo (de `errno`) con un prefijo descriptivo.

### Convención de retorno: 0 = éxito, negativo = error

```c
int mi_funcion(int x) {
    if (x < 0) return -1;  // error
    // ...
    return 0;  // éxito
}
```

### No ignorar warnings

```bash
# ForjarC compila con:
gcc -Wall -Wextra -Werror
```

`-Werror` hace que los warnings sean errores: obliga a resolverlos. Un warning ignorado es un bug esperando pasar a producción.

---

## Seguridad y correctitud

### No usar funciones inseguras

| Insegura | Segura |
|---|---|
| `gets(buf)` | `fgets(buf, sizeof(buf), stdin)` |
| `scanf("%s", buf)` | `scanf("%255s", buf)` o `fgets` |
| `strcpy(dst, src)` | `strncpy(dst, src, sizeof(dst) - 1)` |
| `strcat(dst, src)` | `strncat(dst, src, sizeof(dst) - strlen(dst) - 1)` |
| `sprintf(buf, ...)` | `snprintf(buf, sizeof(buf), ...)` |

### Inicializar siempre

```c
// INCORRECTO — basura en memoria:
int x;
if (x > 0) { ... }  // UB: x puede ser cualquier valor

// CORRECTO:
int x = 0;
```

### Verificar límites de arrays

```c
void escribir(int *arr, int n, int idx, int val) {
    if (idx < 0 || idx >= n) {
        fprintf(stderr, "Índice %d fuera de rango [0, %d)\n", idx, n);
        return;
    }
    arr[idx] = val;
}
```

### Integer overflow

En C, el overflow de `signed int` es **undefined behavior**:

```c
int x = INT_MAX;
x + 1;  // UB — el compilador puede asumir que esto no pasa

// Si se necesita aritmética con overflow, usar unsigned:
unsigned int u = UINT_MAX;
u + 1;  // bien definido: da 0 (wrap around)
```

UBSan (`make ubsan`) detecta overflow en runtime.

---

## Estilo y legibilidad

### Nombres descriptivos

```c
// MAL:
int f(int x, int y);
int a, b, c;

// BIEN:
int calcular_area(int ancho, int alto);
int temperatura_actual, temperatura_max, temperatura_min;
```

### Constantes con #define o const

```c
// Evitar magic numbers:
// MAL:
if (edad >= 18) { ... }

// BIEN:
#define EDAD_MAYORIA 18
if (edad >= EDAD_MAYORIA) { ... }

// O con const (más typesafe):
const int CAPACIDAD_MAXIMA = 100;
```

### Funciones cortas con una responsabilidad

Si una función necesita más de 40 líneas, probablemente hace demasiado. Extraer subfunciones.

### Comentar el POR QUÉ, no el QUÉ

```c
// MAL — describe el código (ya se ve):
// Incrementar i
i++;

// BIEN — explica la razón no obvia:
// El índice del header es 1-based en el protocolo XYZ
i++;

// Workaround: libc tiene un bug con NULL en ciertos sistemas
if (ptr == NULL) { ... }
```

---

## Compilación y warnings

### Activar todos los warnings

```makefile
CFLAGS = -Wall -Wextra -Wpedantic -Wcast-align -Wformat=2 -Wnull-dereference
```

### Compilar con múltiples estándares durante desarrollo

```bash
gcc -std=c11 archivo.c   # estándar moderno
gcc -std=c89 archivo.c   # verificar compatibilidad antigua
```

### Usar sanitizadores siempre durante desarrollo

```bash
make asan   # ASan + UBSan juntos
```

Solo quitar para builds de performance final.

---

## Debugging

### `printf` debugging (el básico)

```c
fprintf(stderr, "[DEBUG] x=%d, ptr=%p\n", x, (void*)ptr);
```

Usar `stderr` (no `stdout`) para que los mensajes no se mezclen con la salida del programa.

### GDB para bugs difíciles

Cuando `printf` no alcanza:
```
F9           → abrir GDB
b mi_funcion → breakpoint
F11          → entrar en la función
p *ptr       → inspeccionar la memoria
```

### ASan para bugs de memoria

```bash
make asan
# Si el programa termina sin output de ASan → no hay bugs de memoria detectados
# Si hay output → leer el stack trace, ir a la línea indicada
```

---

## Testing

### Escribir tests junto con el código (no después)

El flujo TDD en C con Unity:
1. Escribir el test (falla)
2. Implementar la función (el test pasa)
3. Refactorizar

### Tests como documentación

```c
void test_suma_positivos(void) {
    TEST_ASSERT_EQUAL_INT(5, suma(2, 3));
}

void test_suma_con_negativo(void) {
    TEST_ASSERT_EQUAL_INT(-1, suma(2, -3));
}

void test_suma_cero(void) {
    TEST_ASSERT_EQUAL_INT(0, suma(0, 0));
}
```

Los nombres de los tests documentan el comportamiento esperado. Un test que falla dice exactamente qué está roto.

### Coverage como guía

```bash
make coverage
# abrir build/coverage/index.html
```

Las líneas rojas son código no probado. No es necesario llegar al 100%, pero las funciones críticas deben tener cobertura.

---

## Proyectos

### Estructura mínima de un proyecto C en ForjarC

```
mi-proyecto/
├── src/
│   ├── main.c
│   ├── modulo.h
│   └── modulo.c
├── test/
│   ├── unity.c        # copiado de Unity
│   ├── unity.h
│   └── test_modulo.c
├── build/             # gitignored
├── Makefile
├── compile_flags.txt  # para clangd
└── .projectile        # para projectile de Emacs
```

Generado automáticamente con `M-x my/new-c-project`.

### git desde el principio

```bash
git init
git add .
git commit -m "feat: scaffold inicial"
```

Commitear frecuentemente con mensajes descriptivos. El historial es el changelog.
