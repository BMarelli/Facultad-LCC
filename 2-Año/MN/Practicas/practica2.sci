// Ejercicio 1: función que calcula las raíces de un polinomio de forma robusta.

function v = raices(p)
    a = coeff(p,2)
    b = coeff(p,1)
    c = coeff(p,0)
    if (b < 0) then
        v(1) = (2 * c) / (-b + sqrt(b**2 - 4*c*a));
        v(2) = (-b + sqrt(b**2 - 4*c*a)) / 2*a;
    else
        v(1) = (2 * c) / (-b - sqrt(b**2 - 4*c*a));
        v(2) = (-b - sqrt(b**2 - 4*c*a)) / 2*a; 
    end
endfunction

// Ejercicio 3.b: algoritmo de Horner para evaluar un polinomio en un punto.

// Algoritmo recursivo.
function n = horner(p, i, x)
    grado = degree(p)
    if (i == grado) then
        n = coeff(p, i)
    else
        n = coeff(p, i) + x * horner(p, i + 1, x)
    end
endfunction

// Algoritmo iterativo

function n = horner_iterativo(p, x)
    grado = degree(p)
    n = coeff(p, grado)
    for i = grado : -1 : 1
        n = x * n + coeff(p, i - 1)
    end
   
endfunction

// Ejercicio 3.c: (HACER QUE ANDE).
function v = horner_derivada(p, x)
    grado = degree(p)
    b = coeff(p, grado)
    c = b
    for i = (grado - 1) : -1 : 1
         b = x * b + coeff(p, i)
         c = x * c + b
    end
    v(1) = b * x + coeff(p, 0) 
    v(2) = c 
endfunction

// Ejercicio 4:

function y = derivada(f, x, h, n)
    if (n == 0) then
        y = f(x)
    else
        y = (derivada(f, x + h, h, n - 1) - derivada(f, x, h, n - 1)) / h
    end
endfunction

// Ejercicio 5:
function y = taylor(f, x, a, n)
    for k = 0 : n
        p(k + 1) = (derivada(f, a, 10 ^ -3, k) / factorial(k))
    end
    poli = poly(p, "t", "c")
    y = horner_iterativo(poli, x - a)
endfunction