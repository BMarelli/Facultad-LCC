clc

function v = ejercicio5(A)
  [nA, mA] = size(A)

  if nA<>mA then
    error('ejercicio5 - La matriz A debe ser cuadrada')
    abort
  end
  // Chequeamos que sea diagonal dominante
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
    end
  end

  if bool then
    // La matriz es diagonal dominante
    printf("Es diagonal Dominante")
    v = A
  else
    for k=1:nA-1
      [maxC,iC]=max(abs(A(k:nA,k)))
      [maxF,iF]=max(abs(A(k,k:nA)))
      if maxF < maxC then
        kpivot = k-1+iC
        temp = A(kpivot,:); A(kpivot,:) = A(k,:); A(k,:) = temp
      else
        kpivot = k-1+iF
        temp = A(:, kpivot); A(:, kpivot) = A(:, k); A(:, k) = temp
      end
    end

    v = A
  end
endfunction

// CASOS DE PRUEBA:
// --> A = [4 1 3; 5 2 1; 6 1 1]
// --> ejercicio5(A)
//  ans  =
//    6.   2.   1.
//    5.   2.   1.
//    4.   1.   3.

// --> A = [32 5 2; 4 533 1; 3 0 352];
// --> ejercicio5(A)
// Es diagonal Dominante ans  =
//    32.   5.     2.  
//    4.    533.   1.  
//    3.    0.     352.


// No podemos garantizar que el resultado de aplicar la funcion a un matriz, el
// el resultado sea estrictamente dominante ya que si tenemos por ejemplo la
// matriz:
// --> T = ones(4,4)
// --> ejercicio5(T)
//  ans  =
//    1.   1.   1.   1.
//    1.   1.   1.   1.
//    1.   1.   1.   1.
//    1.   1.   1.   1.
// La cual no es diagonal dominante estricta
