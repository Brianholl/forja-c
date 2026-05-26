---
title: "Roadmap de Aprendizaje C"
status: activo
updated: 2026-05-25
tags: [aprendizaje, c, roadmap]
---

# Roadmap de Aprendizaje C

Un camino progresivo desde los fundamentos hasta el código máquina. Cada nivel desbloquea el siguiente y tiene ejercicios concretos en ForjarC.

---

## Nivel 0 — El entorno

Antes de escribir código, dominar las herramientas:

- [ ] Instalar ForjarC (`bash install.sh`)
- [ ] Abrir Emacs, navegar buffers (`C-x b`, `C-x k`)
- [ ] Crear primer proyecto: `M-x my/new-c-project`
- [ ] Compilar y ejecutar con F5
- [ ] Ver errores en flycheck (línea subrayada = error de clangd)
- [ ] Usar autocompletado (TAB o completado automático de company)

**Proyecto:** El Oráculo — `escuela/clase-01-c/`

---

## Nivel 1 — Fundamentos

### 1.1 Tipos, variables y printf

```c
int    x = 42;
float  f = 3.14f;
double d = 3.14159;
char   c = 'A';
char   s[] = "hola";

printf("%d %f %c %s\n", x, f, c, s);
```

Conceptos clave:
- Tipos básicos: `int`, `float`, `double`, `char`, `long`, `unsigned`
- `sizeof()` revela el tamaño real: `sizeof(int)` = 4 en x86-64
- `printf` y sus especificadores: `%d %i %u %f %lf %c %s %p %x`
- Desbordamiento de enteros: `INT_MAX + 1` = `INT_MIN` (UB en signed)

### 1.2 Control de flujo

```c
if (x > 0)      { ... }
for (int i = 0; i < n; i++) { ... }
while (cond)    { ... }
switch (c) { case 'a': ...; break; default: ...; }
```

### 1.3 Funciones

```c
int suma(int a, int b) { return a + b; }
```

- Declaración (`suma.h`) vs definición (`suma.c`) vs llamada (`main.c`)
- Paso por valor: la función recibe una copia
- `static` en funciones = visibilidad solo en ese `.c`
- `inline` sugiere al compilador no crear una llamada de función

**Ejercicio:** Calculadora con todas las operaciones. Separar en `calc.h`, `calc.c`, `main.c`.

---

## Nivel 2 — Punteros y Memoria

El concepto más importante (y más difícil) de C.

### 2.1 Punteros

```c
int x = 10;
int *p = &x;   // p almacena la dirección de x
*p = 20;       // dereferencia: cambia el valor de x a través de p
printf("%p\n", (void*)p);   // imprime la dirección
```

Reglas de oro:
1. Un puntero es solo un número (la dirección de memoria)
2. `*p` lee/escribe en esa dirección
3. Un puntero no inicializado es undefined behavior — siempre inicializar o usar `NULL`

### 2.2 Punteros y arrays

```c
int arr[5] = {1, 2, 3, 4, 5};
int *p = arr;          // arr decae a puntero al primer elemento
printf("%d\n", p[2]);  // equivalente a *(p + 2)
```

La aritmética de punteros avanza en unidades del tipo apuntado: `p + 1` avanza `sizeof(int)` bytes.

### 2.3 Memoria dinámica

```c
int *arr = malloc(n * sizeof(int));
if (arr == NULL) { /* siempre verificar */ exit(1); }

// usar arr...

free(arr);
arr = NULL;  // evitar dangling pointer
```

| Función | Uso |
|---|---|
| `malloc(n)` | Aloca n bytes sin inicializar |
| `calloc(count, size)` | Aloca y pone todo a 0 |
| `realloc(ptr, new_size)` | Redimensiona |
| `free(ptr)` | Libera — solo llamar una vez |

**Errores comunes:**
- Use-after-free: usar `arr` después de `free(arr)`
- Double-free: llamar `free` dos veces al mismo puntero
- Buffer overflow: escribir más allá del tamaño alocado
- Memory leak: no llamar `free` antes de que el puntero salga de scope

**Herramientas de ForjarC para detectarlos:**
```
C-c X a  → ASan: detecta use-after-free, buffer overflow en runtime
C-c X u  → UBSan: detecta undefined behavior
C-c X v  → Valgrind: detecta memory leaks
```

**Ejercicio:** Implementar un array dinámico (vector) en C: `push`, `pop`, `get`, con resize automático.

---

## Nivel 3 — Strings y Arrays

### 3.1 Strings en C

Un string es un array de `char` terminado en `\0`:

```c
char s[] = "hola";   // {'h','o','l','a','\0'} — 5 bytes
char *p  = "mundo";  // puntero a string literal (read-only)
```

Funciones de `<string.h>`:
- `strlen(s)` — longitud sin el `\0`
- `strcpy(dst, src)` — copiar (peligroso sin verificar tamaño)
- `strncpy(dst, src, n)` — versión segura con límite
- `strcmp(a, b)` — comparar (0 = iguales)
- `strcat(dst, src)` — concatenar
- `strtok(s, delim)` — tokenizar

**Regla:** Nunca usar `gets()`. Usar `fgets()`.

### 3.2 Arrays multidimensionales

```c
int matrix[3][4];
// En memoria: fila por fila (row-major)
// matrix[i][j] = *(*(matrix + i) + j)
```

---

## Nivel 4 — Estructuras

### 4.1 `struct`

```c
typedef struct {
    char nombre[64];
    int  edad;
    float nota;
} Alumno;

Alumno a = { .nombre = "Ana", .edad = 16, .nota = 9.5f };
printf("%s tiene %d años\n", a.nombre, a.edad);
```

### 4.2 Punteros a struct

```c
Alumno *p = &a;
p->nota = 10.0f;       // equivalente a (*p).nota = 10.0f
```

### 4.3 Struct con memoria dinámica

```c
typedef struct Nodo {
    int valor;
    struct Nodo *siguiente;
} Nodo;

Nodo *nuevo = malloc(sizeof(Nodo));
nuevo->valor = 42;
nuevo->siguiente = NULL;
```

**Ejercicio:** Lista enlazada simple con `push_front`, `pop_front`, `print`, `free_all`.

---

## Nivel 5 — Archivos y I/O

```c
FILE *f = fopen("datos.txt", "r");
if (f == NULL) { perror("Error"); exit(1); }

char linea[256];
while (fgets(linea, sizeof(linea), f) != NULL) {
    printf("%s", linea);
}

fclose(f);
```

Modos: `"r"` leer, `"w"` escribir (trunca), `"a"` append, `"rb"` binario.

Funciones clave:
- `fprintf(f, ...)` — escribir formateado
- `fscanf(f, ...)` — leer formateado
- `fread/fwrite` — I/O binario
- `fseek/ftell` — navegar posición
- `feof(f)` — detectar fin de archivo

**Ejercicio:** Leer un CSV de alumnos y calcular el promedio de notas.

---

## Nivel 6 — Build y Testing

### 6.1 Makefile

ForjarC usa Makefiles para todos los proyectos. Los targets estándar:

```makefile
make build     # compilar con -g3 -O0
make run       # compilar y ejecutar
make test      # correr tests Unity
make asan      # compilar y correr con AddressSanitizer
make ubsan     # compilar con UndefinedBehaviorSanitizer
make coverage  # generar reporte de cobertura (gcov)
make clean     # borrar build/
```

### 6.2 Testing con Unity

Unity es un framework de tests para C puro (un solo archivo `.c`, sin dependencias):

```c
#include "unity.h"

void setUp(void) {}
void tearDown(void) {}

void test_suma(void) {
    TEST_ASSERT_EQUAL_INT(5, suma(2, 3));
    TEST_ASSERT_EQUAL_INT(-1, suma(0, -1));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_suma);
    return UNITY_END();
}
```

Generar tests con Claude: `C-c A t` en un buffer C.

---

## Nivel 7 — Debug con GDB

ForjarC integra GDB en modo TUI: fuente y assembly simultáneos.

### 7.1 Flujo básico

```
F9          → abrir GDB (compila con -g3 automáticamente)
F10         → next (siguiente línea, no entra en funciones)
F11         → step (entra en funciones)
F8          → continue (hasta el próximo breakpoint)
C-c G       → hydra GDB (todos los comandos)
```

### 7.2 Comandos GDB esenciales

```
b main        → breakpoint en main
b suma:10     → breakpoint en línea 10 de suma.c
p x           → imprimir variable x
p *ptr        → imprimir valor apuntado
p arr[3]      → imprimir elemento de array
x/10i $rip   → 10 instrucciones desde el IP actual
info locals   → todas las variables locales
info registers → todos los registros
bt             → backtrace (pila de llamadas)
disas suma     → desensamblar función suma
```

### 7.3 GDB TUI

Desde dentro de GDB:
```
layout split   → fuente arriba, assembly abajo
layout regs    → agregar panel de registros
si             → step instruction (una instrucción de máquina)
ni             → next instruction
```

---

## Nivel 8 — Código Máquina y Assembly

El punto donde C se vuelve transparente: ver exactamente lo que el compilador genera.

Usar el proyecto `proyectos/c/maquina/`:

### 8.1 Ver el assembly generado

```bash
make asm-intel       # genera build/ejemplos-intel-O0.s (sin optimización)
                     #          build/ejemplos-intel-O2.s (optimizado)
diff build/ejemplos-intel-O0.s build/ejemplos-intel-O2.s | less
```

### 8.2 Desde Emacs

En cualquier buffer C, posicionar el cursor en una función y presionar:
```
C-c d a    → disaster: assembly inline en Emacs
```

### 8.3 Qué observar

| Construcción C | Qué ver en assembly (O0) | O2 |
|---|---|---|
| `a + b` | `add rax, rbx` | puede inline o eliminar |
| `for` loop | `cmp`/`jge` + `inc` | puede vectorizar con `xmm` |
| Función recursiva | `call`/`ret` + stack frame | puede convertir a iterativa |
| `if (a > b)` | `cmp` + `jle`/`jge` | `cmovge` (sin branch) |
| Acceso a struct | `offset + base` con `mov` | |
| `sqrt(x)` | `sqrtss` (registro xmm) | |

### 8.4 Registros x86-64 esenciales

| Registro | Rol |
|---|---|
| `rax` | Valor de retorno de funciones |
| `rdi`, `rsi`, `rdx` | Primeros 3 argumentos de función |
| `rsp` | Stack pointer — apunta al tope del stack |
| `rbp` | Base pointer — frame actual |
| `rip` | Instruction pointer — próxima instrucción |
| `xmm0`–`xmm7` | Registros float/SIMD |

---

## Nivel 9 — Calidad de Código

### 9.1 Herramientas (desde `C-c X`)

| Herramienta | Qué detecta | Cuándo usarla |
|---|---|---|
| ASan | Buffer overflow, use-after-free, double-free | Después de cada nueva funcionalidad |
| UBSan | Integer overflow, null pointer, shift inválido | Con ASan siempre |
| Valgrind | Memory leaks, accesos inválidos | Antes de un release |
| lcov/gcov | Líneas de código no cubiertas por tests | Revisar coverage semanal |
| clang-tidy | Problemas de estilo y bugs estáticos | En CI o antes de commit |

### 9.2 Reglas de C seguro

1. **Verificar malloc:** `if (ptr == NULL) { perror(...); exit(1); }`
2. **Inicializar variables:** `int x = 0;` nunca `int x;` a secas
3. **Bounds checking:** verificar índices antes de acceder a arrays
4. **No usar funciones inseguras:** `gets`, `scanf("%s")`, `strcpy` sin límite
5. **Un free, un malloc:** el dueño del puntero es quien lo libera
6. **Poner a NULL después de free:** `free(p); p = NULL;`

---

## Nivel 10 — Patrones de Diseño en C

C no tiene clases pero sí tiene structs, punteros a función y convenciones. Los snippets de ForjarC implementan los 23 patrones GoF.

### Activar un snippet

En un buffer C, escribir el nombre del patrón y presionar TAB:

```
observer<TAB>    → genera skeleton del patrón Observer
strategy<TAB>    → genera skeleton del patrón Strategy
singleton<TAB>   → genera skeleton del patrón Singleton
```

### Los más útiles en C

| Patrón | Cuándo usarlo |
|---|---|
| **Observer** | Callbacks de eventos (button press, sensor data) |
| **Strategy** | Algoritmos intercambiables (sort, parse, compress) |
| **Factory Method** | Crear objetos sin conocer el tipo concreto |
| **Iterator** | Recorrer colecciones (lista, árbol, buffer) |
| **State** | Máquinas de estado (parser, protocolo, UI) |
| **Command** | Cola de operaciones, undo/redo |
| **Decorator** | Agregar comportamiento sin modificar struct original |

---

## Proyectos de práctica

Ordenados por dificultad:

| # | Proyecto | Conceptos |
|---|---|---|
| 1 | Calculadora (funciones separadas) | Nivel 1: funciones, módulos |
| 2 | Array dinámico (push/pop/resize) | Nivel 2: malloc, realloc |
| 3 | Lista enlazada con memoria dinámica | Nivel 4: structs, punteros a struct |
| 4 | Mini base de datos CSV | Nivel 5: archivos, structs, sorting |
| 5 | Implementar `strlen`, `strcpy`, `strcmp` | Nivel 3: strings desde cero |
| 6 | Parser de JSON mínimo | Nivel 3+5: strings, archivos, state machine |
| 7 | Álgebra lineal: matrix mul | Nivel 8: SIMD en assembly, benchmark O0 vs O2 |
| 8 | Hash map (open addressing) | Nivel 2+4: malloc, structs, algoritmos |
| 9 | Mini shell con fork/exec | Nivel avanzado: syscalls, procesos |
| 10 | Intérprete de Brainfuck | Nivel avanzado: VM, punteros, I/O |
