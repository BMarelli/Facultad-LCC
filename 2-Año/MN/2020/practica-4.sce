// Ejercicio 1
// resolver_triangular_superior :: [[Float]] -> [Float] -> [Float]
// Recibe una matriz triangular superior A (n*n) y un vector columna b (n)
// Resuleve el sistema Ax = b
function x = resolver_triangular_superior(A, b)
  n = size(A, 1)
  x(n) = b(n) / A(n, n)

  for i = (n - 1) : -1 : 1
    x(i) = (b(i) - (A(i, i+1:n) * x(i+1 : n))) / A(i, i)
  end
endfunction

// resolver_triangular_superior :: [[Float]] -> [Float] -> [Float]
// Recibe una matriz triangular inferior A (n*n) y un vector columna b (n)
// Resuleve el sistema Ax = b
function x = resolver_triangular_inferior(A, b)
  n = size(A, 1)
  x(1) = b(1) / A(1, 1)

  for i = 2 : n
    x(i) = (b(i) - A(i, 1:i-1) * x(1:i-1)) / A(i,i)
  end
end

// metodo_eliminacion_gauss :: [[Float]] -> [Float] -> [[[Float]], [Float]]
// Recibe una matriz A (n*n) y un vector columna b (n)
// Devuleve el resultado de aplicar la eliminacion gausseana con A y b (s1, s2)
function [s1, s2] = metodo_eliminacion_gauss(A, b)
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

  for i = 1:(nA-1)
    for j = (i+1):nA
        mjk = Aum(j,i)/Aum(i,i)
        Aum(j,i)=0
        Aum(j,(i+1):(nA+mb)) = Aum(j,(i+1):(nA+mb)) - mjk*Aum(i,(i+1):(nA+mb))
    end
  end
  s1 = Aum(:, 1:nA)
  s2 = Aum(:, nA+1)
endfunction

// resolver_metodo_gauss :: [[Float]] -> [Float] -> [Float]
// Recibe una matriz A (n*n) y un vector columna b (n)
// Resuleve el sistema de ecuaciones Ax = b
function x = resolver_metodo_gauss(A, b)
  [s1, s2] = metodo_eliminacion_gauss(A, b)
  x = resolver_triangular_superior(s1, s2)
endfunction

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

// resolver_metodo_gauss_multiple :: [[Float]] -> [[Float]] -> [[Float]]
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

// --> A = [1 1 0 3; 2 1 -1 1; 3 -1 -1 2; -1 2 3 -1];
// --> matriz_inversa(A)
// ans  =
//  -0.2307692   0.2051282   0.3333333   0.1794872
//   0.0769231   0.4871795  -0.3333333   0.0512821
//   0.         -0.3333333   0.3333333   0.3333333
//   0.3846154  -0.2307692   0.         -0.0769231

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

// --> A = [1 1 0 3; 2 1 -1 1; 3 -1 -1 2; -1 2 3 -1];
// --> matriz_determinante(A)
//  ans  =
//    39.
 
// --> A = [1 2 3; 3 -2 1; 4 2 -1];
// --> matriz_determinante(A)
//  ans  =
//    56.

// metodo_eliminacion_gauss_PP :: [[Float]] -> [Float] -> [[[Float]], [Float]]
// Dada una matriz cuadrada A (n*n) y un vector columna b (n)
// Devuleve el resultado de aplicar la eliminacion gausseana a la matriz
// aumentada [A b]
function [s1,s2] = metodo_eliminacion_gauss_PP(A,b)
  // Esta función obtiene la solución del sistema de ecuaciones lineales A*x=b, 
  // dada la matriz de coeficientes A y el vector b.
  // La función implementa el método de Eliminación Gaussiana con pivoteo parcial.

  [nA,mA] = size(A) 
  [nb,mb] = size(b)

  if nA<>mA then
    error('metodo_eliminacion_gauss_PP - La matriz A debe ser cuadrada')
    abort
  elseif mA<>nb then
    error('metodo_eliminacion_gauss_PP - dimensiones incompatibles entre A y b')
    abort
  end

  Aum = [A b]; // Matriz aumentada
  n = nA;    // Tamaño de la matriz

  // Eliminación progresiva con pivoteo parcial
  for k=1:n-1
    kpivot = k; amax = abs(Aum(k,k));  //pivoteo
    for i=k+1:n
        if abs(Aum(i,k))>amax then
            kpivot = i; amax = Aum(k,i);
        end;
    end;
    temp = Aum(kpivot,:); Aum(kpivot,:) = Aum(k,:); Aum(k,:) = temp;
    
    for i=k+1:n
      for j=k+1:n+1
          Aum(i,j) = Aum(i,j) - Aum(k,j)*Aum(i,k)/Aum(k,k);
      end;
      for j=1:k
          Aum(i,j) = 0;
      end
    end;
  end;

  s1 = Aum(:, 1:nA)
  s2 = Aum(:, nA+1)
endfunction

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

// resolver_metodo_gauss_PP :: [[Float]] -> [Float] -> [Float]
// Dada una matriz cuadrada A (n*n) y un vector columna b (n)
// Devuleve la solucion del sistema Ax = b, utilizando el
// metodo_eliminacion_gauss_PP
function x = resolver_metodo_gauss_PP(A, b)
  [s1, s2] = metodo_eliminacion_gauss_PP(A, b)
  x = resolver_triangular_superior(s1, s2)
endfunction

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
