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
    printf("Realizamos el calculo del radio espectral")
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

// resolver_metodo_SOR :: [[Float]] [Float] [Float] Float Float Int -> [Float]
// Dada una matriz cuadrada A (n*n), un vector columna b (n), un parametro de
// relajacion w, una tolerancia de error e y una cantidad maxima de iteraciones
// Calcula la solucion del sistema Ax = b
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
    // Iteramos por filas
    for i = 1 : nA
      sum = 0
      sumk = 0
      for j = 1 : nA
        // Calculamos las sumas
        if i < j then
          sum = sum + (A(i, j) * x0(j))
        elseif j < i then
          sumk = sumk + (A(i, j) * xk(j))
        end
      end
      // Calculamos los valores de la iteracion actual
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

// --------------------------------------------------------------------------
A = [4 -2 1 0 0 0; -2 6 -2 1 0 0; 1 -2 7 -2 1 0; 0 1 -2 8 -2 1; 0 0 1 -2 6 -2; 0 0 0 1 -2 4];
b = [5 -8 5 10 -8 2]';

// --> es_diagonal_dominante(A)
//  ans  =
//   T

nA = size(A, 1)
I = eye(nA, nA)
N = tril(A)
Norma = I - (inv(N) * A)

// --> converge(Norma)
// Realizamos el calculo del radio espectral ans  =
//   T

// b)
// --> resolver_metodo_guass_seidel(A, b, [0 0 0 0 0 0]', 10^-8, 1000)
// Realizamos el calculo del radio espectral
//    15.
//  ans  =
//    0.4738815
//   -1.1078597
//    0.8887545
//    1.3724305
//   -1.1660218
//   -0.4261185

// Veamos si la matriz es tridiagonal y definida positiva para utilizar el
// metodo SOR con el w maximo:
// --> s = spec(A)
//  s  = 
//    2.6496722
//    2.7198508
//    4.6518745
//    5.2663909
//    7.9958373
//    11.716374

// Como vemos, todos los autovalores son > 0, entonces es definida positiva
// Como podemos ver en la matriz, esta no es tridiagonal, por lo que no podemos
// usar el Teorema 5.
// Por lo tanto, el metodo de gauss_seidel converge con mayor velocidad
