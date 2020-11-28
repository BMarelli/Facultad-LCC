// metodo_interpolacion_largrange :: [Float] [Float] -> Poly
// Dado dos vectores filas x, y (n, n)
// Realiza el metodo interpolacion de largrange
// Devuelve el polinomio de grado (n-1) que interpola por esos puntos
function p = metodo_interpolacion_largrange(x, y)
  n = size(x, 2)

  for k = 1 : n
    xk = [x(1:k-1) x(k+1:n)]
    L(k) = poly(xk, 'x', 'r')
    L(k) = L(k) / horner(L(k), x(k))
  end
  p = 0
  for k = 1 : n
    p = p + (L(k) * y(k))
  end
endfunction 

// CASOS DE PRUEBA:

// diferencias_divididas :: [Float] [Float] -> Float
function v = diferencias_divididas(x, y)
  n = size(x, 2)
  if n == 1 then
    v = y(1)
  else
    v = (diferencias_divididas(x(2:n), y(2:n))-diferencias_divididas(x(1:n-1), y(1:n-1))) / x(n) - x(1)
  end
endfunction
// CASOS DE PRUEBA:

// metodo_interpolacion_dif_divididas_newton :: [Float] [Float] -> Poly
// Dado dos vectores filas x, y (n, n)
// Realiza el metodo interpolacion diferencia divididas de newton
// Devuelve el polinomio de grado ? que interpola por esos puntos
function p = metodo_inter_dif_divididas_newton(x, y)
  xn = size(x, 2)
  yn = size(x, 2)

  if xn <> yn then
    error("metodo_interpolacion_dif_divididas_newton - x y tienen que tener el mismo tamaño")
    abort
  end

  p = diferencias_divididas(x(1), y(1))
  p_n = 1
  for i = 2 : xn
    p_n = poly(x(1:i-1), 'x', 'r')
    p = p + p_n * diferencias_divididas(x(1:i), y(1:i))
  end
endfunction
// CASOS DE PRUEBA:


// Ejercicio 1
// a)
// --> x = [0 0.2 0.4 0.6];
// --> y = exp(x);
// --> p = metodo_interpolacion_largrange(x(2:3), y(2:3))
//  p  =                   
//    0.9509808 +1.3521097x
// --> horner(p, 1/3)
//  ans  =
//    1.4016841
// --> p = metodo_interpolacion_largrange(x, y)
//  p  =
//                             2            3
//    1 +1.0025541x +0.4770775x  +0.2261038x 
// --> horner(p, 1/3)
//  ans  =
//    1.3955675

// --> p = metodo_interpolacion_largrange(x(2:3), y(2:3))
//  p  = 
//    0.9509808 +1.3521097x
// --> horner(p, 1/3)
//  ans  =
//    1.4016841
// --> p = metodo_inter_dif_divididas_newton(x, y)
//  p  =
//                             2            3
//    1 +1.5337985x -2.4121869x  +1.3913159x 
// --> horner(p, 1/3)
//  ans  =
//    1.2947756

// b) CONSULTA: De todos hay que hacer!
