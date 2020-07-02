#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#define T_EXPONENTE 16
#define T_MANTISA 18
#define SESGO 30000

int isOne(long n, int pos) { return (n >> pos) & 1; }

void printbin(int n, int nbits) {
  for (int i = nbits - 1; i >= 0; i--) {
    printf("%d", isOne(n, i));
  }
  printf("\n");
}

typedef struct {
  int signo : 1;
  int exponente : T_EXPONENTE;
  int mantisa : T_MANTISA;
} numero;

numero numero_crear(int signo, int mantisa, int exponente) {
  numero x;
  x.signo = signo;
  x.exponente = exponente;
  x.mantisa = mantisa;

  return x;
}

int numero_es_cero(numero x) { return x.exponente == 0 && x.mantisa == 0; }

int numero_es_infinito(numero x) { return x.exponente == (1 << T_EXPONENTE - 1) && x.mantisa == 0; }

int numero_es_nan(numero x) { return x.exponente == (1 << T_EXPONENTE - 1) && x.mantisa != 0; }

numero numero_cero() {
  numero x;
  x.signo = 0;
  x.exponente = 0;
  x.mantisa = 0;

  return x;
}

numero numero_inf(int signo) {
  numero x;
  x.signo = signo;
  x.exponente = 1 << T_EXPONENTE - 1;
  x.mantisa = 0;

  return x;
}

numero numero_nan() {
  numero x;
  x.signo = 0;
  x.exponente = 1 << T_EXPONENTE - 1;
  x.mantisa = 1;

  return x;
}

numero numero_suma(numero x1, numero x2) {
  if (numero_es_nan(x1) | numero_es_nan(x2)) return numero_nan();

  if (numero_es_cero(x1)) return x2;
  if (numero_es_cero(x2)) return x1;

  if (numero_es_infinito(x1)) {
    if (numero_es_infinito(x2)) {
      if (x1.signo == x2.signo)
        return x1;
      else
        return numero_nan();
    }

    return x1;
  } else if (numero_es_infinito(x2))
    return x2;

  numero resultado;

  int maximoExponente = (x1.exponente > x2.exponente) ? x1.exponente : x2.exponente;
  if (x1.exponente >= x2.exponente)
    x2.mantisa >>= x1.exponente - x2.exponente;
  else
    x1.mantisa >>= x2.exponente - x1.exponente;

  resultado.exponente = maximoExponente;
  unsigned long long mantisa;
  if (x1.signo == x2.signo) {
    resultado.signo = x1.signo;
    mantisa = (unsigned long long)x1.mantisa + (unsigned long long)x2.mantisa;
  } else {
    if (x1.mantisa > x2.mantisa) {
      mantisa = (unsigned long long)x1.mantisa - (unsigned long long)x2.mantisa;
      resultado.signo = x1.signo;
    } else {
      mantisa = (unsigned long long)x2.mantisa - (unsigned long long)x1.mantisa;
      resultado.signo = x2.signo;
    }
  }

  if (mantisa >> T_MANTISA) {
    resultado.exponente++;
    resultado.mantisa = mantisa << 1;
  } else {
    resultado.mantisa = mantisa;
  }

  return resultado;
}

numero numero_producto(numero x1, numero x2) {
  if (numero_es_nan(x1) | numero_es_nan(x2)) return numero_nan();

  if ((numero_es_infinito(x1) && numero_es_cero(x2)) || (numero_es_infinito(x2) && numero_es_cero(x1)))
    return numero_nan();

  if (numero_es_infinito(x1) || numero_es_infinito(x2)) return numero_inf((x1.signo + x2.signo) % 2);

  numero resultado;
  resultado.signo = x1.signo ^ x2.signo;
  resultado.exponente = x1.exponente + x2.exponente - SESGO;
  resultado.mantisa = (unsigned long long)x1.mantisa * (unsigned long long)x2.mantisa >> (T_MANTISA - 2);

  if (!(resultado.mantisa & (1 << 17))) {
    resultado.mantisa <<= 1;
    resultado.exponente--;
  }

  return resultado;
}

int main() {
  numero x1 = numero_crear(0, 1 << 17 | 1 << 16, SESGO);
  numero x2 = numero_crear(0, 1 << 17, SESGO);

  printbin(x1.mantisa, T_MANTISA);
  printbin(x2.mantisa, T_MANTISA);
  printbin(numero_producto(x1, x2).exponente, T_EXPONENTE);
  printbin(numero_producto(x1, x2).mantisa, T_MANTISA);
  printbin(numero_suma(x1, x2).exponente, T_EXPONENTE);
  printbin(numero_suma(x1, x2).mantisa, T_MANTISA);

  return 0;
}
