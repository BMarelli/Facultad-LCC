#if !defined(__UTIL__)
#define __UTIL__

// isOne: long int -> int
// Recibe un entero "n" de 64 bits y un entero  0 <= "pos" <= 63,
// Devuelve 1 si el número tiene un 1 en la posición pos de su representación
// binaria.
int isOne(long n, int pos);

// printbin32: int -> void
// Recibe un entero de 32 bits,
// Lo imprime en binario.
void printbin32(int n);

// printbin64: long -> void
// Recibe un entero de 64 bits,
// Lo imprime en binario.
void printbin64(long n);

// rotar: long* long* long* -> void
// Recibe punteros a tres enteros ("a", "b", "c") de 64 bits,
// Los rota sin usar variables auxiliares, es decir: a, b, c -> c, a, b
void rotar(long *a, long *b, long *c);

// mult: unsigned unsigned -> unsigned
// Recibe dos enteros positivos,
// Devuelve su producto.
unsigned mult(unsigned a, unsigned b);

#endif  // __UTIL__
