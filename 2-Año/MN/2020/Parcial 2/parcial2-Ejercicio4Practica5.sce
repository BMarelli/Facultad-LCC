clc
// converge :: [[Float]] ->Bool
// Dada una matriz cuadrada Norma (n*n) (La matriz de iteracion)
// Determina si el sistema converge o no a una solucion
function bool = converge(Norma)
  n(1) = norm(A, 1)
  n(2) = norm(A, 'inf')
  n(3) = norm(A, 'fro')
  n(4) = norm(A)
  if min(n) >= 1 then
    bool = max(abs(spec(Norma))) < 1
  else
    bool = %T
  end
endfunction

// CASOS DE PRUEBA:
// --> A = [3 4 0; 1 -8 3; 1 2 2];
// --> I = eye(3, 3);
// --> N = diag(diag(A));
// --> Norma = I - (inv(N) * A);
// --> converge(Norma)
//  ans  =
//   T

// es_diagonal_dominante :: [[Float]] -> Bool
// Dada una matriz cuadrada A (n*n)
// Determina si es una matriz diagonal dominante
function bool = es_diagonal_dominante(A)
  [nA, mA] = size(A)
  bool = %T
  for i = 1 : nA
    suma = 0
    for j = 1:mA
      if j <> i then
          suma = suma + abs(A(i,j))
      end
    end
    if suma >= abs(A(i,i))
        bool = %F
        return
    end
  end
endfunction

// CASOS DE PRUEBA:
// --> A = [9 3 4; 2 -7 2; 2 5 -10];
// --> es_diagonal_dominante(A)
//  ans  =
//   T

// --> A = [1 4 4; 4 1 4; 4 4 1];
// --> es_diagonal_dominante(A)
//  ans  =
//   F

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

// resolver_metodo_guass_seidel :: [[Float]] [Float] [Float] Float Int->[Float]
// Dada una matriz cuadrada A (n*n), un vector columna b (n), un vector columna
// inicial x0 (n), una tolerancia de error e y la cantidad maxima de iteraciones
// Calcula la solucion del sistema Ax = b
function x = resolver_metodo_guass_seidel(A, b, x0, e, iter)
  [nA, mA] = size(A)
  [nb, mb] = size(b)

  if nA<>mA then
    error('resolver_metodo_guass_seidel - La matriz A debe ser cuadrada')
    abort
  elseif mA<>nb then
    error('resolver_metodo_guass_seidel - distintas dimensiones entre A y b')
    abort
  end

  TA = A
  Tb = b
  Tx0 = x0
  if ~es_diagonal_dominante(A) then
    for k=1:nA-1
      [v,i]=max(abs(A(k:nA,k)))
      kpivot = k-1+i
      temp = TA(kpivot,:); TA(kpivot,:) = TA(k,:); TA(k,:) = temp
      temp = Tb(kpivot,:); Tb(kpivot,:) = Tb(k,:); Tb(k,:) = temp
      temp = Tx0(kpivot,:); Tx0(kpivot,:) = Tx0(k,:); Tx0(k,:) = temp
    end

    if es_diagonal_dominante(TA) then
      A = TA
      b =Tb
      x0 = Tx0
    end
  end

  I = eye(nA, nA)
  N = tril(A)
  Norma = I - (inv(N) * A)

  if ~converge(Norma) then
    x = %nan
    error('resolver_metodo_guass_seidel - El sistema Ax = b no converge')
    abort
  end

  xk = x0
  for cnt = 0 : iter
    for i = 1 : nA
      sum = 0
      sumk = 0
      for j = 1 : nA
        if i < j then
          sum = sum + (A(i, j) * x0(j))
        elseif j < i then
          sumk = sumk + (A(i, j) * xk(j))
        end
      end
      xk(i) = (b(i) - sum - sumk) / A(i, i)
    end

    // Criterio de corte
    if norm(xk - x0) < e then
      x = xk
      disp(cnt)
      return
    end

    x0 = xk
  end

  disp(cnt)
  x = xk
endfunction

// CASOS DE PRUEBA:
// --> A = [2 1 1 0; 4 3 3 1; 8 7 9 5; 6 7 9 8];
// --> b = [1 2 3 4]';
// --> resolver_metodo_guass_seidel(A, b, [0 0 0 0]', 10^-8, 200)
//    115.
//  ans  =
//    1.
//    0.5
//   -1.5
//    1.

// --> A = [12 432 -31; -432 423 0; 34 -342 41];
// --> b = [11 22 33]';
// --> resolver_metodo_guass_seidel(A, b, [0 0 0]', 10^-8, 200)
//    23.
//  ans  =
//    0.1253751
//    0.1800521
//    2.2028062

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

// ---------------------------------------------------------------------------

// Ejercicio 4
function [A, b] = ejercicio4(N)
  A = 8*eye(N,N)
      + 2*diag(ones(N-1,1),1)
      + 2*diag(ones(N-1,1),-1)
      + diag(ones(N-3,1),3)
      + diag(ones(N-3,1),-3)
  b = ones(N,1)
endfunction

// --> [A, b] = ejercicio4(100);
// --> tic(); resolver_metodo_guass_seidel(A, b, zeros(500, 1), 10^-6, 200);t=toc()
//    1.
//  t  = 
//    0.0800665

// --> tic(); resolver_metodo_gauss_PP(A, b); t=toc()
//  t  = 
//    2.2381173

// --> [A, b] = ejercicio4(500);
// --> tic(); resolver_metodo_guass_seidel(A, b, zeros(1000, 1), 10^-11, 1000);t=toc()
//    1.
//  t  = 
//    1.8244663
// --> tic(); resolver_metodo_gauss_PP(A, b); t=toc()
//  t  = 
//    292.70544
