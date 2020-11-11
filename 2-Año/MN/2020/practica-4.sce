// TODO: Realizar nuevos casos de prueba para cada funcion
// CONSULTA: Cantidad de operaciones

// Ejercicio 1
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

// resolver_triangular_superior :: [[Float]] [Float] -> [[Float], Int]
// Recibe una matriz triangular inferior A (n*n) y un vector columna b (n)
// Resuleve el sistema Ax = b
// op: Cantidad de operaciones realizadas
function [x, op] = resolver_triangular_inferior(A, b)
  n = size(A, 1)
  x(1) = b(1) / A(1, 1)
  op = 1

  // Sustitucion progresiva
  for i = 2 : n
    x(i) = (b(i) - A(i, 1:i-1) * x(1:i-1)) / A(i,i)
    op = op + 2 + (i - 1) + (i - 2)
  end
endfunction

// CASOS DE PRUEBA:
// --> A = [-21 0 0; 5 34 0; -112 23 -3];
// --> b = [1 2 3]';
// --> [x, op] = resolver_triangular_inferior(A, b)
//  op  = 
//    9.
//  x  = 
//   -0.047619
//    0.0658263
//    1.2824463

// --> A = [-5.535 0 0; 763.5 314.32 0; -0.43231 23.53 -1.12];
// --> b = [0.324 0.78364 -1]';
// --> [x, op] = resolver_triangular_inferior(A, b)
//  op  = 
//    9.
//  x  = 
//   -0.0585366
//    0.1446816
//    3.9550573

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

// Ejercicio 2
// --> A = [1 1 0 3; 2 1 -1 1; 3 -1 -1 2; -1 2 3 -1];
// --> b = [4 1 -3 4]';
// --> resolver_metodo_gauss(A, b)
//  ans  =
//   -1.
//    2.
//    0.
//    1.

// --> A = [1 -1 2 -1; 2 -2 3 -3; 1 1 1 0; 1 -1 4 3];
// --> b = [-8 -20 -2 4]';
// No se puede resolver con el metodo_eliminacion_gauss
// Necesitamos realizar pivoteos, lo hacemos con metodo_eliminacion_gauss_PP
// Podemos utilizar, A \ b

// --> A = [1 1 0 4; 2 1 -1 1; 4 -1 -2 2; 3 -1 -1 2];
// --> b = [2 1 0 -3]';
// --> resolver_metodo_gauss(A, b)
//  ans  =
//   -4.
//    0.6666667
//   -7.
//    1.3333333

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

// matriz_determinante :: [[Float]] -> Float
// Dada una matriz cuadrada A (n*n)
// Calcula el determinante de A con el metodo_eliminacion_gauss
function v = matriz_determinante(A)
  [nA, mA] = size(A)

  // Chequeamos si la matriz es cuadrada
  if nA <> mA then
    error('matriz_determinante - La matriz A debe ser cuadrada')
    abort
  end

  S = metodo_eliminacion_gauss(A, zeros(nA, nA))

  v = prod(diag(S))
endfunction

// CASOS DE PRUEBA:
// --> A = [415 521 431; 432 0 0;43 32 0];
// --> matriz_determinante(A)
//  ans  =
//    5958144.
 
// --> A = [1 2 3; 3 -2 1; 4 2 -1];
// --> matriz_determinante(A)
//  ans  =
//    56.

// metodo_eliminacion_gauss_PP :: [[Float]] [Float] -> [[[Float]], [Float]]
// Dada una matriz cuadrada A (n*n) y un vector columna b (n)
// Devuleve el resultado de aplicar la eliminacion gausseana con pivoteo parcial 
// a la matriz aumentada [A b]
function [s1,s2] = metodo_eliminacion_gauss_PP(A,b)
  [nA,mA] = size(A) 
  [nb,mb] = size(b)

  if nA<>mA then
    error('metodo_eliminacion_gauss_PP - La matriz A debe ser cuadrada')
    abort
  elseif mA<>nb then
    error('metodo_eliminacion_gauss_PP - dimensiones incompatibles entre A y b')
    abort
  end

  // Utilizamos la matiz Aumentada
  Aum = [A b];

  // Eliminación progresiva con pivoteo parcial
  for k=1:nA-1
    kpivot = k; Aum_max = abs(Aum(k,k));  //pivoteo
    for i=k+1:nA
        if abs(Aum(i,k))>Aum_max then
            kpivot = i; Aum_max = Aum(k,i);
        end;
    end;
    temp = Aum(kpivot,:); Aum(kpivot,:) = Aum(k,:); Aum(k,:) = temp;
    
    for i=k+1:nA
      for j=k+1:nA+1
        Aum(i,j) = Aum(i,j) - Aum(k,j)*Aum(i,k)/Aum(k,k);
      end;
      Aum(i,1:k) = 0;
    end;
  end;

  // Separamos la matriz aumentada resultante
  s1 = Aum(:, 1:nA)
  s2 = Aum(:, nA+1)
endfunction

// CASOS DE PRUEBA:

// --> A = [1 -1 2 -1; 2 -2 3 -3; 1 1 1 0; 1 -1 4 3];
// --> b = [-8 -20 -2 4]';
// --> [s1, s2] = metodo_eliminacion_gauss_PP(A, b)
//  s2  = 
//   -2.
//   -16.
//    14.
//   -0.8
//  s1  = 
//    1.   1.   1.    0. 
//    0.  -4.   1.   -3. 
//    0.   0.   2.5   4.5
//    0.   0.   0.   -0.4

// --> A = [415 521 431; 432 0 0;43 32 0];
// --> b = [2 -5 2]';
// --> [s1, s2] = metodo_eliminacion_gauss_PP(A, b)
//  s2  = 
//   -5.
//    6.8032407
//    2.0798278
//  s1  = 
//    432.   0.     0.       
//    0.     521.   431.     
//    0.     0.    -26.472169

// resolver_metodo_gauss_PP :: [[Float]] [Float] -> [Float]
// Dada una matriz cuadrada A (n*n) y un vector columna b (n)
// Devuleve la solucion del sistema Ax = b, utilizando el
// metodo_eliminacion_gauss_PP
function x = resolver_metodo_gauss_PP(A, b)
  [s1, s2] = metodo_eliminacion_gauss_PP(A, b)
  x = resolver_triangular_superior(s1, s2)
endfunction

// CASOS DE PRUEBA:
// --> A = [415 521 431; 432 0 0;43 32 0];
// --> b = [2 -5 2]';
// --> resolver_metodo_gauss_PP(A, b)
//  ans  =
//   -0.0115741
//    0.0780527
//   -0.0785666

// --> A = [422 43 -52 57768; 345 0 452 0; 543 543 0 0; 34 21 -1 -1];
// --> b = [-4 -55 66 0]';
// --> resolver_metodo_gauss_PP(A, b)
//  ans  =
//   -0.1942146
//    0.3157616
//    0.0265576
//    0.0011384

// Ejercicio 5
// --> A = [1 1 0 3; 2 1 -1 1; 3 -1 -1 2; -1 2 3 -1];
// --> b = [4 1 -3 4]';
// --> resolver_metodo_gauss_PP(A, b)
//  ans  =
//   -1.
//    2.
//    0.
//    1.

// --> A = [1 -1 2 -1; 2 -2 3 -3; 1 1 1 0; 1 -1 4 3];
// --> b = [-8 -20 -2 4]';
// --> resolver_metodo_eliminacion_gauss_PP(A, b)
//  ans  =
//  -7.
//   3.
//   2.
//   2.

// --> A = [1 1 0 4; 2 1 -1 1; 4 -1 -2 2; 3 -1 -1 2];
// --> b = [2 1 0 -3]';
// --> resolver_metodo_gauss_PP(A, b)
//  ans  =
//   -4.
//    0.6666667
//   -7.
//    1.3333333

// Ejercicio 6
function [x, op] = resolver_tridiagonal(A, b)
  [nA,mA] = size(A) 
  [nb,mb] = size(b)

  if nA<>mA then
    error('resolver_tridiagonal - La matriz A debe ser cuadrada')
    abort
  elseif mA<>nb then
    error('resolver_tridiagonal - dimensiones incompatibles entre A y b')
    abort
  end

  Aum = [A b]
  op = 0
  for i = 2 : nA
    m = Aum(i, i-1) / Aum(i-1, i-1)
    Aum(i, i-1) = 0
    Aum(i, i) = Aum(i, i) - Aum(i-1, i) * m
    Aum(i, nA+mb) = Aum(i, nA+mb) - Aum(i-1, nA+mb) * m
    op = op + 5
  end

  for i = nA-1 : -1 :1
    m = Aum(i, i+1) / Aum(i+1, i+1)
    Aum(i, i+1) = 0
    Aum(i, nA+mb) = Aum(i, nA+mb) - Aum(i+1, nA+mb) * m
    op = op + 3
  end

  for i = 1 : nA
    x(i) = Aum(i, nA+mb) / Aum(i, i)
    op = op + 1
  end
end

// CASOS DE PRUEBA:
// --> A = [2 3 0 0 0; 7 3 -2 0 0; 0 412 42 -223 0; 0 0 -43 32 -2; 0 0 0 -1 -2];
// --> b = [11 22 33 44 55]';
// --> [x, op] = resolver_tridiagonal(A, b)
//  op  = 
//    37.
//  x  = 
//    3.2576129
//    1.4949247
//    2.6440323
//    3.1119208
//   -29.05596

// matriz_factorizar_LU :: [[Float]] -> [[[Float]], [[Float]], [[Float]]]
// Dada una matriz A (n*n)
// Devuelve el resultado de la factorizacion LU talque: PA = LU
function [L, U, P] = matriz_factorizar_LU(A)
  [nA, mA] = size(A)

  if nA <> mA then
    error('matriz_factorizar_LU - La matriz A debe ser cuadrada')
    abort
  end

  U = A
  L = eye(nA, nA)
  P = eye(nA, nA)

  for k = 1 : nA - 1
    maxUik = abs(U(k, k))
    for i=k+1 : nA
      // Obtenemos el maximo Uik
      if (abs(U(i, k)) > maxUik) then
        maxUik = abs(U(i, k))
        
        // Realizamos los intercambios de las filas
        temp = U(k, k:nA)
        U(k, k:nA) = U(i, k:nA)
        U(i, k:nA) = temp

        // Realizamos los intercambios de las filas
        temp = L(k, 1:k-1)
        L(k, 1:k-1) = L(i, 1:k-1)
        L(i, 1:k-1) = temp

        // Realizamos los intercambios de las filas
        temp = P(k, :)
        P(k, :) = P(i, :)
        P(i, :) = temp
      end
    end

    // Realizamos la eliminaciones
    for j = k + 1 : nA
      L(j, k) = U(j, k) / U(k, k)
      U(j, k:nA) = U(j, k:nA) - (L(j, k) * U(k, k:nA))
    end
  end
endfunction

// CASOS DE PRUEBA:
// --> A = [422 43 -52 57768; 345 0 452 0; 543 543 0 0; 34 21 -1 -1];
// --> [L, U, P] = matriz_factorizar_LU(A)
//  P  = 
//    0.   0.   1.   0.
//    1.   0.   0.   0.
//    0.   1.   0.   0.
//    0.   0.   0.   1.
//  U  = 
//    543.        543.   0.          0.       
//    0.         -379.  -52.         57768.   
//    0.          0.     499.33509  -52585.646
//   -7.105D-15   0.     0.         -1899.9618
//  L  = 
//    1.          0.          0.          0.
//    0.7771639   1.          0.          0.
//    0.6353591   0.9102902   1.          0.
//    0.0626151   0.0343008   0.0015694   1.

// --> A = [415 521 431; 432 0 0;43 32 0];
// --> [L, U, P] = matriz_factorizar_LU(A)
//  P  = 
//    0.   1.   0.
//    1.   0.   0.
//    0.   0.   1.
//  U  = 
//    432.   0.     0.       
//    0.     521.   431.     
//    0.     0.    -26.472169
//  L  = 
//    1.          0.          0.
//    0.9606481   1.          0.
//    0.099537    0.0614203   1.

// Ejercicio 7
// --> A = [2 1 1 0; 4 3 3 1; 8 7 9 5; 6 7 9 8];
// --> [L, U, P] = matriz_factorizar_LU(A)
//  P  = 
//    0.   0.   1.   0.
//    0.   0.   0.   1.
//    0.   1.   0.   0.
//    1.   0.   0.   0.
//  U  = 
//    8.   7.     9.          5.       
//    0.   1.75   2.25        4.25     
//    0.   0.    -0.8571429  -0.2857143
//    0.   0.     0.          0.6666667
//  L  = 
//    1.     0.          0.          0.
//    0.75   1.          0.          0.
//    0.5   -0.2857143   1.          0.
//    0.25  -0.4285714   0.3333333   1.

// Ejercicio 8
// --> A = [1.012 -2.132 3.104; -2.132 4.096 -7.013; 3.104 -7.013 0.014];
// --> [L, U, P] = matriz_factorizar_LU(A)
//  P  = 
//    0.   0.   1.
//    0.   1.   0.
//    1.   0.   0.

//  U  = 
//    3.104  -7.013       0.014    
//    0.     -0.7209188  -7.003384 
//    0.      0.          1.5989796
//  L  = 
//    1.          0.          0.
//   -0.6868557   1.          0.
//    0.3260309  -0.2142473   1.

// --> A = [2.1756 4.0231 -2.1732 5.1967;
//          -4.0231 6.0000 0 1.1973;
//          -1.0000 5.2107 1.1111 0;
//          6.0235 7.0000 0 4.1561];
// --> [L, U, P] = matriz_factorizar_LU(A)
//  P  = 
//    0.   0.   0.   1.
//    0.   1.   0.   0.
//    1.   0.   0.   0.
//    0.   0.   1.   0.
//  U  = 
//    6.0235   7.          0.       4.1561   
//    0.       10.675305   0.       3.9731622
//    0.       0.         -2.1732   3.1392381
//    0.       0.          0.      -0.0768597
//  L  = 
//    1.          0.          0.          0.
//   -0.6679007   1.          0.          0.
//    0.3611854   0.1400243   1.          0.
//   -0.1660164   0.596968   -0.5112737   1.

// resolver_factorizacion_LU :: [[Float]] [Float] -> [Float]
// Dada una matriz cuadrada A (n*n) y un vector columna b (n)
// Calcula la factorizacion LU : PA = LU
// Devuelve la solucion del sitema: Ly = Pb, donde Ux = y
// Este sistema es equivalente a: Ax = b
function x = resolver_factorizacion_LU(A, b)
  [L, U, P] = matriz_factorizar_LU(A)
  y = resolver_triangular_inferior(L, (P*b))
  x = resolver_triangular_superior(U, y)
endfunction

// CASOS DE PRUEBA:

// --> A = [1 1 0 4; 2 1 -1 1; 4 -1 -2 2; 3 -1 -1 2];
// --> b = [2 1 0 -3]';
// --> resolver_factorizacion_LU(A, b)
//  ans  =
//   -4.
//    0.6666667
//   -7.
//    1.3333333

// --> A = [53 563 36; -4 5 0; 0 0 -545];
// --> b = [7 7 7]';
// --> resolver_factorizacion_LU(A, b)
//  ans  =
//   -1.5509289
//    0.1592569
//   -0.012844

// Ejercicio 9
function [x, P] = ejercicio9(A, b)
  [L, U, P] = matriz_factorizar_LU(A)
  y = resolver_triangular_inferior(L, (P*b))
  x = resolver_triangular_superior(U, y)
endfunction

// a)
// --> A = [1 2 -2 1; 4 5 -7 6; 5 25 -15 -3; 6 -12 -6 22];
// --> b = [1 2 0 1]';
// --> [x, P] = ejercicio9(A, b)
//  P  = 
//    0.   0.   0.   1.
//    0.   0.   1.   0.
//    0.   1.   0.   0.
//    1.   0.   0.   0.
//  x  = 
//    9.8333333
//   -6.1666667
//   -5.5
//   -7.5

// b)
// --> A = [1 2 -2 1; 4 5 -7 6; 5 25 -15 -3; 6 -12 -6 22];
// --> b = [2 2 1 0]';
// --> [x, P] = ejercicio9(A, b)
//  P  = 
//    0.   0.   0.   1.
//    0.   0.   1.   0.
//    0.   1.   0.   0.
//    1.   0.   0.   0.
//  x  = 
//    19.5
//   -17.
//   -18.
//   -19.5

// matriz_factorizar_LU_Doolittle :: [[Float]] -> [[[Float]], [[Float]]]
// Recibe una matriz cuadrada A (n*n)
// Devuelve el resultado de la factorizacion con el metodo de Doolittle
function [L, U] = matriz_factorizar_LU_Doolittle(A)
  [nA, mA] = size(A)

  if nA <> mA then
    error('matriz_factorizar_LU_Doolittle - La matriz A debe ser cuadrada')
    abort
  end

  L = zeros(nA, nA)
  U = zeros(nA, nA)

  // Nos movemos por las columnas
  for j = 1 : nA
    // Nos movemos por las filas
    for i = 1 : nA
      if i <= j then
        U(i, j) = A(i, j)
        // Calculamos U(i, j)
        for k = 1 : i - 1
            U(i, j) = U(i, j) - L(i, k) * U(k, j)
        end
      end
      if j <= i then
          L(i, j) = A(i, j)
          // Calculamos L(i, j)
          for k = 1 : j-1
              L(i, j) = L(i, j) - L(i, k) * U(k, j)
          end
          L(i, j) = L(i, j) / U(j, j)
      end
    end
  end

endfunction

// CASOS DE PRUEBA:
// --> A = [53 563 36; -4 5 0; 0 0 -545];
// --> [L, U] = matriz_factorizar_LU_Doolittle(A)
//  U  = 
//    53.   563.        36.      
//    0.    47.490566   2.7169811
//    0.    0.         -545.     
//  L  = 
//    1.          0.   0.
//   -0.0754717   1.   0.
//    0.          0.   1.

// --> A = inv([0 2 4; 1 -1 -1; 1 -1 2]);
// --> [L, U] = matriz_factorizar_LU_Doolittle(A)
//  U  = 
//    0.5   1.3333333  -0.3333333
//    0.   -0.6666667  -0.3333333
//    0.    0.          0.5      
//  L  = 
//    1.   0.    0.
//    1.   1.    0.
//    0.   0.5   1.

// resolver_factorizacion_LU_Doolittle :: [[Float]] [Float] -> [Float]
// Dada una matriz cuadrada A (n*n) y un vector columna b (n)
// Devuleve la solucion del sistema Ax = b utilizando 
// matriz_factorizar_LU_Doolittle para resolver el sistema equivalente:
// Ly = b, donde y = Ux, A = LU
function x = resolver_factorizacion_LU_Doolittle(A, b)
  [L, U] = matriz_factorizar_LU_Doolittle(A)
  y = resolver_triangular_inferior(L, b)
  x = resolver_triangular_superior(U, y)
endfunction

// CASOS DE PRUEBA:
// --> A = inv([0 2 4; 1 -1 -1; 1 -1 2]);
// --> b = [4324 4324 3244]';
// --> resolver_factorizacion_LU_Doolittle(A, b)
//  ans  =
//    21624.
//   -3244.
//    6488.

// --> A = [43 53; -1 -3];
// --> b = [0.1 100]';
// --> resolver_factorizacion_LU_Doolittle(A, b)
//  ans  =
//    69.740789
//   -56.580263

// Ejercicio 10
// --> A = [1 2 3 4; 1 4 9 16; 1 8 27 64; 1 16 81 256];
// --> b = [2 10 44 190]';
// --> resolver_factorizacion_LU_Doolittle(A, b)
//  ans  =
//   -1.
//    1.
//   -1.
//    1.

// matriz_factorizar_Cholesky :: [[Float]] -> [[[Float]], Int]
// Dada una matriz cuadrada simetrica A (n*n)
// Devuelve una matriz superior U talque: (U')U = A
// ind = 1  si se obtuvo la factorización de Cholesky.
//     = 0  si A no es definida positiva
function [U,ind] = matriz_factorizar_Cholesky(A)

  //******************
  eps = 1.0e-8
  //******************
  
  n = size(A,1)
  U = zeros(n,n)
  
  for k = 1:n
    if k == 1 then
      t = A(k, k)
    else
      t = A(k,k) - U(1:k-1,k)'*U(1:k-1,k)
    end
    if t <= eps then
        printf('matriz_factorizar_Cholesky - Matriz no definida positiva.\n')
        ind = 0
        return
    end
    U(k,k) = sqrt(t)
    for j = k+1:n
        if k == 1 then
          U(k, j) = A(k, j) / U(k, k)
        else
          U(k,j) = (A(k,j) - U(1:k-1,k)'*U(1:k-1,j))/U(k,k)
        end
    end
  end
  ind = 1
  
endfunction

// CASOS DE PRUEBA:
// --> A = [4 3 2 1; 3 3 2 1; 2 2 2 1; 1 1 1 1];
// --> [U, ind] = matriz_factorizar_Cholesky(A)
//  ind  = 
//    1.
//  U  = 
//    2.   1.5         1.          0.5      
//    0.   0.8660254   0.5773503   0.2886751
//    0.   0.          0.8164966   0.4082483
//    0.   0.          0.          0.7071068
// --> U'*U == A
//  ans  =
//   T T T T
//   T T T T
//   T T T T
//   T T T T
// --> A = [4 -4 6 -6; -4 20 -22 26; 6 -22 61 -59; -6 26 -59 108];
// --> [U, ind] = matriz_factorizar_Cholesky(A)
//  ind  = 
//    1.
//  U  = 
//    2.  -2.   3.  -3.
//    0.   4.  -4.   5.
//    0.   0.   6.  -5.
//    0.   0.   0.   7.
// --> U'*U == A
//  ans  =
//   T T T T
//   T T T T
//   T T T T
//   T T T T

// Ejercicio 11
// --> A = [16 -12 8 -16; -12 18 -6 9; 8 -6 5 -10; -16 9 -10 46];
// --> [U, ind] = matriz_factorizar_Cholesky(A)
//  ind  = 
//    1.
//  U  = 
//    4.  -3.   2.  -4.
//    0.   3.   0.  -1.
//    0.   0.   1.  -2.
//    0.   0.   0.   5.
// --> U'*U == A
//  ans  =
//   T T T T
//   T T T T
//   T T T T
//   T T T T

// --> B = [4 1 1; 8 2 2; 1 2 3];
// --> [U, ind] = matriz_factorizar_Cholesky(B)
//  ind  = 
//    1.
//  U  = 
//    2.   0.5         0.5      
//    0.   1.3228757   1.3228757
//    0.   0.          1.       
// Como B no es simetrica, la matriz no puede ser factorizada => U' * U != B 

// --> C = [1 2; 2 4];
// --> [U, ind] = matriz_factorizar_Cholesky(C)
// matriz_factorizar_Cholesky - Matriz no definida positiva.
//  ind  = 
//    0.
//  U  = 
//    1.   2.
//    0.   0.

// resolver_factorizacion_Cholesky :: [[Float]] [Float] -> [Float]
// Dada una matriz cuadrada simetrica A (n*n) y un vector columna b (n)
// Resuleve el sistema Ax = b utilizando matriz_factorizar_Cholesky
// para resolver el sistema equivalente: U'y = b, donde y = Ux, A = (U')U
function x = resolver_factorizacion_Cholesky(A, b)
  [U, ind] = matriz_factorizar_Cholesky(A)

  if ind == 0 then
    x = %nan
  else
    y = resolver_triangular_inferior(U', b)
    x = resolver_triangular_superior(U, y)
  end
endfunction

// CASOS DE PRUEBA:
// --> A = [4 3 2 1; 3 3 2 1; 2 2 2 1; 1 1 1 1];
// --> b = [19 18 17 16]';
// --> resolver_factorizacion_Cholesky(A, b)
//  ans  =
//    1.
//   -1.026D-15
//    3.263D-15
//    15.

// --> A = [4 -4 6 -6; -4 20 -22 26; 6 -22 61 -59; -6 26 -59 108];
// --> b = [-4 6 2 -7]';
// --> resolver_factorizacion_Cholesky(A, b)
//  ans  =
//   -0.9895125
//    0.4637188
//    0.1558957
//   -0.1462585


// Ejercicio 12
// --> A = [16 -12 8; -12 18 -6; 8 -6 8];
// --> b = [76 -66 46]';
// --> resolver_factorizacion_Cholesky(A, b)
//  ans  =
//    3.
//   -1.
//    2.
