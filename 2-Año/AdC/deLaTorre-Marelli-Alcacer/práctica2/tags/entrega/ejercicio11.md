# Ejercicio 11

```cpp {.line-numbers}
#include <stdio.h>

int f(char a, int b, char c, long d, char e, short f, int g, int h) {
  printf("a: %p\n", &a);
  printf("b: %p\n", &b);
  printf("c: %p\n", &c);
  printf("d: %p\n", &d);
  printf("e: %p\n", &e);
  printf("f: %p\n", &f);
  printf("g: %p\n", &g);
  printf("h: %p\n", &h);
  return 0;
}

int main(void) { return f('1', 2, '3', 4, '5', 6, 7, 8); }
```

Al llamar a `f`, los argumentos son pasados en los siguientes registros:

```x86asm
a: %rdi (8 bits)
b: %rsi (32 bits)
c: %rdx (8 bits)
d: %rcx (64 bits)
e: %r8 (8 bits)
f: %r9 (16 bits)
```

Los argumentos restantes, son pasados por la pila:

| Pila                   |         |
| -----------            | :-----: |
| r.a. (main)            |         |
| %rbp (anterior a main) |         |
| 8 (int h - 32 bits)    |         |
| 7 (int g - 32 bits)    |         |
| r.a. (f)               | <- %rsp |

Despues del prólogo de la función `f`:

| Pila                   |                |
| ---------------------- | :------------: |
| r.a. (main)            |                |
| %rbp (anterior a main) |                |
| 8 (int h - 32 bits)    |                |
| 7 (int g - 32 bits)    |                |
| r.a. (f)               |                |
| %rbp (anterior a f)    | <- %rsp = %rbp |
