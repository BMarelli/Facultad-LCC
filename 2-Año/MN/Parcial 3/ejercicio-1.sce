// metodo_de_la_potencia :: [[Float]] [Float] Float Int -> [Float, [Float]]
// Dada una matriz cuadrada A (n*n), un vector columna z0 (n), una toleracia
// de error e y un cantidad maxima de iteraciones
// Calcula el maximo autovalor (tiene que ser unico) de A 
// y su respectivo autovector
function [l, v, i] = metodo_de_la_potencia(A, z0, eps, iter)
  [nA, mA] = size(A)

  if nA<>mA then
    error('metodo_de_la_potencia - La matriz A debe ser cuadrada')
    abort
  end

  // eps = 1e-10

  w = A * z0
  z = w / norm(w, "inf")
  i = 1
  while (norm(z - z0) > eps) && (i < iter)
    z0 = z
    w = A * z0
    z = w / norm(w, "inf")
    i = i + 1
  end
  
  [wk, k] = max(abs(w))
  l = w(k) / z(k)
  v = z
endfunction
// CASOS DE PRUEBA:
// --> A = [1 2 3;2 -4 -5; 3 -5 0];
// --> [l, v, i] = metodo_de_la_potencia(A, [1 0 0]', 10^-7, 300)
//  i  = 
//    300.
//  v  = 
//    0.4402798
//   -1.
//   -0.7376547
//  l  = 
//   -8.5688329

// --> A = [2 0 1; -1 -1 2; 2 2 1];
// --> [l, v, i] = metodo_de_la_potencia(A, [1 0 0]', 10^-10, 1000)
//  i  = 
//    91.
//  v  = 
//    0.8263205
//    0.2787715
//    1.
//  l  = 
//    3.2101841
function y = resolver_ejercicio()
  A = [5 -2 1; 3 0 1; 0 0 2];
  [l, v, i] = metodo_de_la_potencia(A, [1 0 0]', 10^-8, 200)
  printf("Mayor autovalor:")
  disp(l)
  printf("Autovector asociado:")
  disp(v)
  printf("Numero de Iteraciones:")
  disp(i)

  // Obtenemos el todos los autovalores
  spc = spec(A)
  //Graficamos los autovalores
  scatter(real(spec(A)), imag(spec(A)))
  y=0
endfunction

// --> resolver_ejercicio()
// Mayor autovalor:
//    3.
// Autovector asociado:
//    1.
//    1.
//    0.
// Numero de Iteraciones:
//    42.
//  ans  =
//    0.
