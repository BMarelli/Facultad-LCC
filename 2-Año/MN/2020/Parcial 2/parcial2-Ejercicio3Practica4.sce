// resolver_triangular_superior :: [[Float]] [Float] -> [[Float], Int]
// Recibe una matriz triangular superior A (n*n) y un vector columna b (n)
// Resuleve el sistema Ax = b
// op: Cantidad de operaciones realizadas
function [x, op] = resolver_triangular_superior(A, b)
  n = size(A, 1)
  x(n) = b(n) / A(n, n)
  op = 1
  // Sustitucion regresiva
  for i = (n - 1) : -1 : 1
    x(i) = (b(i) - (A(i, i+1:n) * x(i+1 : n))) / A(i, i)
    op = op + 2 + (n - i) + (n - i - 1)
  end
endfunction
// CASOS DE PRUEBA:
// --> A = [1 22 12; 0 54 -43; 0 0 -1];
// --> b = [22 333 4444]';
// --> [x, op] = resolver_triangular_superior(A, b)
//  op  = 
//    9.
//  x  = 
//    131066.63
//   -3532.5741
//   -4444.

// --> A = [9 22 -12; 0 -54 10; 0 0 200];
// --> b = [-19 7 -43]';
// --> [x, op] = resolver_triangular_superior(A, b)
//  op  = 
//    9.
//  x  = 
//   -1.9835802
//   -0.1694444
//   -0.215

// metodo_eliminacion_gauss :: [[Float]] [Float] -> [[[Float]], [Float], Int]
// Recibe una matriz A (n*n) y un vector columna b (n)
// Devuleve el resultado de aplicar la eliminacion gausseana con A y b (s1, s2)
// op: Cantidad de operaciones realizadas
function [s1, s2, op] = metodo_eliminacion_gauss(A, b)
  [nA, mA] = size(A)
  [nb, mb] = size(b)

  // Chequeamos si las dimenciones son correctas
  if nA <> mA then
    error('metodo_eliminacion_gauss - La matriz A debe ser cuadrada')
    abort
  elseif nA <> nb then
    error('metodo_eliminacion_gauss - dimensiones incompatibles entre A y b')
    abort
  end

  // Utilizamos la matiz Aumentada
  Aum = [A b]
  op = 0

  // Realizamos la eliminacion gausseana
  for i = 1:(nA-1)
    for j = (i+1):nA
        mjk = Aum(j,i)/Aum(i,i)
        op = op + 1
        Aum(j,i)=0
        Aum(j,(i+1):(nA+mb)) = Aum(j,(i+1):(nA+mb)) - mjk*Aum(i,(i+1):(nA+mb))
        op = op + (2 * (nA + mb - i))
    end
  end

  // Separamos la matriz aumentada resultante
  s1 = Aum(:, 1:nA) 
  s2 = Aum(:, nA+1)
endfunction

// CASOS DE PRUEBA:
// En este caso podemos ver que necesitamos hacer pivoteos
// --> A = [0 2 4; 1 -1 -1; 1 -1 2];
// --> b = [0 0.375 0]';
// --> [s1, s2] = metodo_eliminacion_gauss(A, b)
//  s2  = 
//    0.
//    Nan
//    Nan
//  s1  = 
//    0.   2.    4. 
//    0.  -Inf  -Inf
//    0.   0.    Nan

// --> A = [3.2 -3.2 0; -3.2 6.4 -3.2;0 -3.2 3.52];
// --> b = [0 1 0]';
// --> [s1, s2] = metodo_eliminacion_gauss(A, b)
//  s2  = 
//    0.
//    1.
//    1.
//  s1  = 
//    3.2  -3.2   0.  
//    0.    3.2  -3.2 
//    0.    0.    0.32

// resolver_metodo_gauss :: [[Float]] [Float] -> [Float]
// Recibe una matriz A (n*n) y un vector columna b (n)
// Resuleve el sistema de ecuaciones Ax = b
function x = resolver_metodo_gauss(A, b)
  [s1, s2, op1] = metodo_eliminacion_gauss(A, b)
  [x, op2] = resolver_triangular_superior(s1, s2)
  disp(op1 + op2)
endfunction

// CASOS DE PRUEBA:
// --> A = [3.2 -3.2 0; -3.2 6.4 -3.2;0 -3.2 3.52];
// --> b = [0 1 0]';
// --> resolver_metodo_gauss(A, b)
//  ans  =
//    3.4375
//    3.4375
//    3.125

// --> A = [42 434 673; -343 644 -1455; 345 542 -45443];
// --> b = [421 -5421 321]';
// --> resolver_metodo_gauss(A, b)
//  ans  =
//    14.340308
//   -0.5651442
//    0.0950663

// resolver_metodo_gauss_multiple :: [[Float]] [[Float]] -> [[Float]]
// Dada una matriz A (n*n) y una matriz b (n*n)
// Resuleve los sistemas Ax(i) = b(i)
function x = resolver_metodo_gauss_multiple(A, b)
  nA = size(A, 1)
  mb = size(b, 2)
  // x = zeros(nA, nA)
  for i = 1 : mb
    x(1:nA, i) = resolver_metodo_gauss(A, b(1:nA, i))
  end
endfunction

// CASOS DE PRUEBA:
// --> A = [42 434 673; -343 644 -1455; 345 542 -45443]';
// --> b = [-434 36536 -54531; 21543 43243 -4; 3341 -3214 0]';
// --> resolver_metodo_gauss_multiple(A, b)
//  ans  =
//    65.443746   154.87582   5.1377594
//    11.103094  -40.240131  -8.7529902
//    1.8136927   3.5821758   0.3563434

// --> A = [1.234 6.2352 534.243; 54.452 -554.34 425.21; -525 24.34 423];
// --> b = [1 22 333; 4 55 666; 7 88 999]';
// --> resolver_metodo_gauss_multiple(A, b)
//  ans  =
//   -0.635241   -1.2680833  -1.9009257
//   -0.0986413  -0.2138745  -0.3291077
//    0.0044903   0.0129124   0.0213345


// Ejercicio 3
// --> A = [1 2 3; 3 -2 1; 4 2 -1];
// --> b = [14 9 -2; 2 -5 2; 5 19 12];
// --> resolver_metodo_gauss_multiple(A, b)
//  ans  =
//    1.   2.   2.
//    2.   5.   1.
//    3.  -1.  -2.

// matriz_inversa :: [[Float]] -> [[Float]]
// Dada una matriz A (n*n)
// Calcula la matriz inversa de A
function inv = matriz_inversa(A)
  [nA, mA] = size(A)

  // Chequeamos si la matriz es cuadrada
  if nA <> mA then
    error('matriz_inversa - La matriz A debe ser cuadrada')
    abort
  end
  
  inv = resolver_metodo_gauss_multiple(A, eye(nA, nA))
endfunction

// CASOS DE PRUEBA:

// --> A = [42 434 673; -343 644 -1455; 345 542 -45443]';
// --> matriz_inversa(A)
// ans  =
// 0.0033687   0.0019033   0.0000483
// -0.0023762   0.0002533  -0.000015 
// 0.000126    0.0000201  -0.0000208

// --> A = [1 2 3; 3 -2 1; 4 2 -1];
// --> matriz_inversa(A)
//  ans  =
//    0.      0.1428571   0.1428571
//    0.125  -0.2321429   0.1428571
//    0.25    0.1071429  -0.1428571
