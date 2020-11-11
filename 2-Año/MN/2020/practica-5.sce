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
  bool = %F
  for i = 1 : nA
    suma = sum(abs(A(i, 1:i-1))) + sum(abs(A(i, i+1:nA)))

    if A(i, i) > suma then
      bool = %T
    end
  end
endfunction

// CASOS DE PRUEBA:
// --> A = [3 4 0; 1 -8 3; 1 2 5];
// --> es_diagonal_dominante(A)
//  ans  =
//   T

// --> A = [3 4 0; 1 -8 3; 1 2 2];
// --> es_diagonal_dominante(A)
//  ans  =
//   F

// pivotear :: [[Float]] -> [[Float]]
// Dada una matriz cuadrada A (n*n)
// Pivotea las filas y devuelve una matriz con diagonal fuerte
function v = pivotear(A)
  nA = size(A, 1)
  for k=1:nA-1
    [v,i]=max(abs(A(k:nA,k)))
    kpivot = k-1+i
    temp = A(kpivot,:); A(kpivot,:) = A(k,:); A(k,:) = temp
  end

  v = A
endfunction

// CASOS DE PRUEBA:
// --> A = [3 4 0; 1 -8 3; 1 2 2];
// --> pivotear(A)
//  ans  =
//    3.   4.   0.
//    1.  -8.   3.
//    1.   2.   2.

// resolver_metodo_jacobi :: [[Float]] [Float] [Float] Float Int -> [Float]
// Dada una matriz cuadrada A (n*n), un vector columna b (n), un vector columna
// inicial x0 (n), una tolerancia de error e y la cantidad maxima de iteraciones
// Calcula la solucion del sistema Ax = b
function x = resolver_metodo_jacobi(A, b, x0, e, iter)
  [nA,mA] = size(A) 
  [nb,mb] = size(b)

  if nA<>mA then
    error('resolver_metodo_jacobi - La matriz A debe ser cuadrada')
    abort
  elseif mA<>nb then
    error('resolver_metodo_jacobi - distintas dimensiones entre A y b')
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
  N = diag(diag(A))
  Norma = I - (inv(N) * A)

  if ~converge(Norma) then
    x = %nan
    error('resolver_metodo_jacobi - El sistema Ax = b no converge')
    abort
  end

  xk = x0
  for cnt = 0 : iter
    for i = 1 : nA
      suma = 0
      for j = 1 : nA
        if i <> j then
          suma = suma + (A(i, j) * x0(j))
        end
      end
      
      xk(i) = (b(i) - suma) / A(i, i)
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
  x = x0
endfunction

// CASOS DE PRUEBA:
// --> A = [2 1 1 0; 4 3 3 1; 8 7 9 5; 6 7 9 8];
// --> b = [1 2 3 4]';
// --> resolver_metodo_jacobi(A, b, [0 0 0 0]', 10^-8, 200)
// resolver_metodo_jacobi - El sistema Ax = b no converge

// --> A = [12 432 -31; -432 423 0; 34 -342 41];
// --> b = [11 22 33]';
// --> resolver_metodo_jacobi(A, b, [0 0 0]', 10^-8, 200)
//    78.
//  ans  =
//    0.1253751
//    0.1800521
//    2.2028062

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


// Ejercicio 1
// --> A = [0 2 4; 1 -1 -1; 1 -1 2];
// --> b = [0 0.375 0]';
// Sabemos por el Teorema 3, si la matriz es diagonal dominante => converge
// --> es_diagonal_dominante(A)
//  ans  =
//   F
// En este caso no es. Luego chequeamos si las normas son < 1 y si esto no pasa
// chequeamos si el radio espectral es < 1 (Teorema 1 y 2)
// --> At = pivotear(A)
// --> I = eye(3, 3);
// --> N = diag(diag(At));
// --> Norma = I - (inv(N) * At);
// --> converge(Norma)
//  ans  =
//   F
// Como el radio espectral es mayor a 1, el sistema no converge para el metodo
// de Jacobi
// En Gauss Seidel, hacemos lo mismo, pero N es la triangular inferior
// --> At = pivotear(A)
// --> I = eye(3, 3);
// --> N = tril(At)
// --> Norma = I - (inv(N) * At);
// --> converge(Norma)
//  ans  =
//   F
// Luego por el teorema 2, el sistema no converge por el teorema 3 y 4

// --> resolver_metodo_jacobi(A, b, [0 0 0]', 10^-2, 200)
// resolver_metodo_jacobi - El sistema Ax = b no converge
// --> resolver_metodo_guass_seidel(A, b, [0 0 0]', 10^-2, 200)
// resolver_metodo_guass_seidel - El sistema Ax = b no converge

// --> A = [1 -1 0; -1 2 -1;0 -1 1.1];
// --> b = [0 1 0]';

// --> es_diagonal_dominante(A)
//  ans  =
//   T
// Como es diagonal dominante, el sistema converge en los 2 metodos

// --> resolver_metodo_jacobi(A, b, [0 0 0]', 10^-2, 200)
//    185.
//  ans  =
//    10.847707
//    10.854629
//    9.8615514
// --> resolver_metodo_guass_seidel(A, b, [0 0 0]', 10^-2)
//    92.
//  ans  =
//    10.840455
//    10.847707
//    9.8615514

// Ejercicio 2
// --> A = [10 1 2 3 4; 1 9 -1 2 -3; 2 -1 7 3 -5; 3 2 3 12 -1; 4 -3 -5 -1 15];
// --> b = [12 -27 14 -17 12]';

// --> resolver_metodo_jacobi(A, b, [0 0 0 0 0]', 10^-6, 200)
//    78.
//  ans  =
//    1.0000002
//   -2.0000002
//    2.9999997
//   -1.9999999
//    0.9999998

// --> resolver_metodo_guass_seidel(A, b, [0 0 0 0 0]', 10^-6, 200)
//    42.
//  ans  =
//    1.0000002
//   -2.0000002
//    2.9999997
//   -2.
//    0.9999998

// Ejercicio 3
// ejercicio3 :: Int -> [[Int]]
// Dado un entero n
// Devuelve la matriz de iteracion (n*n) de la matriz dada en el ejercicio
function Norma = ejercicio3(n)
  A = 2*eye(n, n) + diag(-1 * ones(1, n-1), -1) + diag(-1 * ones(1, n-1), 1)
  N = tril(A)
  Norma = eye(n, n) - (inv(N) * A)
end

// --> ejercicio3(4)
//  ans  =
//    0.   0.5      0.      0.  
//    0.   0.25     0.5     0.  
//    0.   0.125    0.25    0.5 
//    0.   0.0625   0.125   0.25
// --> ejercicio3(5)
//  ans  =
//    0.   0.5       0.       0.      0.  
//    0.   0.25      0.5      0.      0.  
//    0.   0.125     0.25     0.5     0.  
//    0.   0.0625    0.125    0.25    0.5 
//    0.   0.03125   0.0625   0.125   0.25

// Ejercicio 4
function [A, b] = ejercicio4(N)
  A = 8*eye(N,N)
      + 2*diag(ones(N-1,1),1)
      + 2*diag(ones(N-1,1),-1)
      + diag(ones(N-3,1),3)
      + diag(ones(N-3,1),-3)
  b = ones(N,1)
endfunction

// --> [A, b] = ejercicio4(500);
// --> tic(); resolver_metodo_guass_seidel(A, b, zeros(500, 1), 10^-6);t=toc()
//  t  = 
//    0.9944964
// --> tic(); resolver_metodo_gauss_PP(A, b); t=toc()
//  t  = 
//    261.22322

// --> [A, b] = ejercicio4(1000);
// --> tic(); resolver_metodo_guass_seidel(A, b, zeros(1000, 1), 10^-12);t=toc()
//  t  = 
//    3.9880213
// --> tic(); resolver_metodo_gauss_PP(A, b); t=toc()
// Lo deje correr por aproximadamente 10 mins y no habia terminado y por eso
// decidi cortarlo

// TODO: Cuando converge este metodo
function x = resolver_metodo_SOR(A, b, x0, w, e, iter)
  [nA, mA] = size(A)
  [nb, mb] = size(b)

  if nA<>mA then
    error('resolver_metodo_SOR - La matriz A debe ser cuadrada')
    abort
  elseif mA<>nb then
    error('resolver_metodo_SOR - distintas dimensiones entre A y b')
    abort
  end

  N = tril(A)
  invN = inv(N)
  I = eye(nA, nA)
  Norma = I - (invN * A)
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
      xk(i) = (1 - w) * x0(i) + (b(i) - sum - sumk) * w / A(i, i)
    end

    // Criterio de corte
    if norm(xk - x0) < e then
      x = xk
      disp(cnt)
      return
    end

    x0 = xk
  end

  x = x0
endfunction

// CASOS DE PRUEBA:
// --> A = [-2 1 0 0; 1 -2 0.3 0; 0 0.3 -2 -1; 0 0 -1 -2];
// --> b = [31 42 53 64]';
// --> T = (eye(A) - inv(diag(diag(A))) * A);
// --> rho = (max(abs(spec(T))));
// --> w = 2 / (1 + sqrt(1 - rho ^ 2 ));
// --> resolver_metodo_SOR(A, b, [0 0 0 0]', w, 10^-8, 1000)
//    12.
//  ans  =
//   -36.923611
//   -42.847222
//   -22.569444
//   -20.715278

// Ejercicio 5
// --> A = [4 3 0; 3 4 -1; 0 -1 4];
// --> b = [24 30 -24]';

// --> resolver_metodo_guass_seidel(A, b, [0 0 0]', 10^-8, 200)
//    40.
//  ans  =
//    3.
//    4.
//   -5.

// --> T = (eye(A) - inv(diag(diag(A))) * A);
// --> rho = (max(abs(spec(T))));
// --> w = 2 / (1 + sqrt(1 - rho ^ 2 ));

// --> resolver_metodo_SOR(A, b, [0 0 0]', w, 10^-8, 1000)
//    16.
//  ans  =
//    3.
//    4.
//   -5.
