// metodo_interpolacion_largrange :: [Float] [Float] -> Poly
// Dado dos vectores filas x, y (n, n)
// Realiza el metodo interpolacion de largrange
// Devuelve el polinomio de grado (n-1) que interpola por esos puntos
function p = metodo_interpolacion_largrange(x, y)
  n = size(x, 2)
  
  // Calculamos los Lk
  for k = 1 : n
    xk = [x(1:k-1) x(k+1:n)]
    L(k) = poly(xk, 'x', 'r')
    L(k) = L(k) / horner(L(k), x(k))
  end

  // Calculamos el polinomio de interpolacion
  p = 0
  for k = 1 : n
    p = p + (L(k) * y(k))
  end
endfunction 

// CASOS DE PRUEBA:
// --> deff('y=f(x)', 'y=2*cos(x^2)')
// --> x = [0: 0.2 : 2];
// --> y = f(x);
// --> p = metodo_interpolacion_largrange(x, y)
//  p  = 
//                             2           3            4            5            6            7            8
//    2 -0.0240061x +0.3452245x  -2.016925x  +5.4050814x  -12.343681x  +15.106009x  -11.803874x  +5.7644718x 
//                        9            10
//             -1.5088964x  +0.1572004x 
// --> f(1.5)
//  ans  =
//   -1.2563472
// --> horner(p, 1.5)
//  ans  =
//   -1.2563222

// diferencias_divididas :: [Float] [Float] -> Float
// Dado dos vectores filas x, y (n, n)
// Calcula las diferencias divididas
function v = diferencias_divididas(x, y)
  n = size(x, 2)
  if n == 1 then
    v = y(1)
  else
    v = (diferencias_divididas(x(2:n), y(2:n))-diferencias_divididas(x(1:n-1), y(1:n-1))) / (x(n) - x(1))
  end
endfunction

// CASOS DE PRUEBA:
// --> deff('y=f(x)', 'y=2*cos(x^2)')
// --> x = [0: 0.2 : 2];
// --> y = f(x);
// --> p = metodo_interpolacion_dif_divididas_newton(x,y)
//  p  = 
//                             2            3            4            5            6            7            8
//    2 -0.0240061x +0.3452244x  -2.0169246x  +5.4050803x  -12.343679x  +15.106007x  -11.803873x  +5.7644712x 
//                        9            10
//             -1.5088962x  +0.1572004x  
// --> f(1.5)
//  ans  =
//   -1.2563472
// --> horner(p, 1.5)
//  ans  =
//   -1.2563222


// metodo_interpolacion_dif_divididas_newton :: [Float] [Float] -> Poly
// Dado dos vectores filas x, y (n, n)
// Realiza el metodo interpolacion diferencia divididas de newton
// Devuelve el polinomio de grado (n-1) que interpola por esos puntos
function p = metodo_interpolacion_dif_divididas_newton(x, y)
  xn = size(x, 2)
  yn = size(x, 2)

  if xn <> yn then
    error("metodo_interpolacion_dif_divididas_newton - x y tienen que tener el mismo tamaño")
    abort
  end

  p = diferencias_divididas(x(1), y(1))
  p_n = 1
  // Calculamos las diferencias divididas y el polinomio de interpolacion
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

// --> p = metodo_interpolacion_dif_divididas_newton(x(2:3), y(2:3))
//  p  =                 
//    0.9509808 +1.3521097x
// --> horner(p, 1/3)
//  ans  =
//    1.4016841
// --> p = metodo_interpolacion_dif_divididas_newton(x, y)
//  p  = 
//                             2            3
//    1 +1.0025541x +0.4770775x  +0.2261038x 
// --> horner(p, 1/3)
//  ans  =
//    1.3955675

// b) CONSULTA: De todos hay que hacer!
// --> x = [0 0.2 0.4 0.6];
// --> y = exp(x);

// Ejercicio 4
// --> x = [2:.1:2.5];
// --> J0 = [0.2239 0.1666 0.1104 0.0555 0.0025 -0.0484];
// -> p = metodo_interpolacion_dif_divididas_newton(x, J0)
//  p  = 
//                             2            3      4            5
//    38.8381 -84.5671x +75.23x  -33.633333x  +7.5x  -0.6666667x 
// --> horner(p, 2.15)
//  ans  =
//    0.1383688
// --> horner(p, 2.35)
//  ans  =
//    0.0287313
// b) papel

// Ejercicio 5
// Primera parte papel
// --> p = metodo_interpolacion_largrange([0:3], [1 3 3 3])
//  p  = 
//                     2            3
//    1 +3.6666667x -2x  +0.3333333x 
// --> horner(p, 2.5)
//  ans  =
//    2.875

// Ejercicio 6
function p = ejercicio_6()
  x = [-1, 1, 2, 4]
  dd = [2, 1, -2, 2]

  p = dd(1)
  p_n = 1
  for i = 2 : 4
    p_n = poly(x(1:i-1), 'x', 'r')
    p = p + p_n * dd(i)
  end
endfunction

// a)
// --> p = ejercicio_6()
//  p  = 
//            2    3
//    9 -x -6x  +2x 
// b)
// --> horner(p, 0)
//  ans  =
//    9.

// metodo_minimos_cuadrados :: [Float] [Float] Int -> Poly
// Dado 2 vectores x, y (n, n) y un entero gr
// Calcula un polinomio de grado gr que interpola por los puntos dados
function f = metodo_minimos_cuadrados(x, y, gr)
n = size(x, 2)
A = zeros(n, gr)

// Creamos la matriz A. (nuestras funciones son 
// los polinomios: 1, x, x², x³, x⁴,...)
for j = 1 : gr + 1
  for i = 1 : n
    A(i, j) = x(i)^(j - 1)
  end
end

// Hallamos los coeficientes aplicando la fórmula.
At = A'
coef = (At * A) \ (At * y')

// Armamos la función
f = poly(coef', "x", "c")
endfunction
// CASOS DE PRUEBA:


// function f = metodo_minimos_cuadrados_fs(x, y, f, gr)
//   n = size(x, 2)
//   A = zeros(n, gr)
  
//   // Creamos la matriz A. (nuestras funciones son 
//   // los polinomios: 1, x, x², x³, x⁴,...)
//   for j = 1 : gr + 1
//     for i = 1 : n
//       A(i, j) = f(j-1) (x(i))
//     end
//   end
  
//   // Hallamos los coeficientes aplicando la fórmula.
//   At = A'
//   coef = (At * A) \ (At * y')
  
//   // Armamos la función
//   f = poly(coef', "x", "c")
// endfunction

// Ejercicio 7
// --> x = [0 .15 .31 .5 .6 .75];
// --> y = [1 1.004 1.31 1.117 1.223 1.422];
// --> p = metodo_minimos_cuadrados(x, y, 1)
//  p  = 
//    0.9960666 +0.4760174x
// --> p = metodo_minimos_cuadrados(x, y, 2)
//  p  = 
//                                    2
//    1.007732 +0.3542987x +0.1635646x 
// --> p = metodo_minimos_cuadrados(x, y, 3)
//  p  = 
//                                     2          3
//    0.9653196 +1.6154731x -4.3450249x  +3.97241x 

// Ejercicio 8
function y = dibujar_ejercicio6(p1, p2, p3, x, y)
  plot(x, horner(p1, x))
  plot(x, horner(p2, x), 'r')
  plot(x, horner(p2, x), 'g')
  scatter(x, y, 'd')
  a=gca();
  a.x_location = "origin";
  a.y_location = "origin";
  y = 0
endfunction
// --> x = [4 4.2 4.5 4.7 5.1 5.5 5.9 6.3 6.8 7.1];
// --> y = [102.56 113.18 130.11 142.05 167.53 195.14 224.87 256.73 299.5 326.72];
// --> p1 = metodo_minimos_cuadrados(x, y, 1)
//  p1  = 
//   -194.13824 +72.084518x
// --> p2 = metodo_minimos_cuadrados(x, y, 2)
//  p2  = 
//                                     2
//    1.2355604 -1.1435234x +6.6182109x
// --> p3 = metodo_minimos_cuadrados(x, y, 3)
//  p3  = 
//                                     2            3
//    3.4290944 -2.3792211x +6.8455778x  -0.0136746x
// --> dibujar(p1 ,p2 ,p3, x, y)
//  ans  =
//    0.
// Comentario: Podemos ver que el polinomio p2 es tapado por el p3
// Para ver los polinomios por separados, se puede comentar la linea del plot(p)


// Ejercicio 9
// dibujar_ejercicio9 :: (Float -> Float) [Int] -> [Poly]
// Dada una funcion f y un vector fila ns (n) -> n = 5 sino hay problema con
//                                               colors
// Utiliza el metodo_interpolacion_largrange para calcular el polinomio de
// interpolacion con la cantidad ns(i) de nodos uniformemente espaciados.
// Grafica el error del polinomio en el intervalo [-5 : .1 :5]
// Devuelve los polinomios de interpolacion 
function p = dibujar_ejercicio9(f, ns)
  n = size(ns, 2)
  colors = ['r', 'g', 'p', 'y', 'c'] // Colores para graficar
  for i = 1 : n
    x = linspace(-5, 5, ns(i))
    p(i) = metodo_interpolacion_largrange(x, f(x))
    x_ = [-5 : .1 :5]
    plot(x_, f(x_) - horner(p(i), x_), colors(i))
    a=gca();
    a.x_location = "origin";
    a.y_location = "origin";
  end 
endfunction
// --> deff('y=g(x)', 'y=1./(1+x^2)') <-- Definimos la g con ./ para poder
//                                        aplicarla con un vector fila
// --> ns = [2, 4, 6, 10, 14];
// --> p = dibujar_ejercicio9(g, ns)
//  p  = 
//    0.0384615
//                                    2            3
//    0.2929864 -2.992D-17x -0.010181x  +1.437D-18x 
//                                     2            3            4            5
//    0.5673077 +1.594D-17x -0.0692308x  -2.087D-18x  +0.0019231x  +8.470D-21x 
//                                     2            3            4            5            6            7            8
//    0.8615382 +2.782D-16x -0.3304369x  +1.191D-16x  +0.0491656x  +4.879D-19x  -0.0028746x  +2.911D-18x  +0.0000554x 
//                        9
//             -7.729D-21x 
//                                     2            3            4            5            6            7            8
//    0.9572139 +7.198D-17x -0.6106978x  +1.581D-15x  +0.1994189x  -3.285D-15x  -0.0324618x  +4.376D-16x  +0.0026526x 
//                        9            10            11            12            13
//             -5.272D-17x  -0.0001032x   +1.833D-18x   +0.0000015x   -3.770D-20x  

// polinomio_Chebyshev :: Int -> [Poly, [Float]]
// Dado un entero n >= 0
// Calcula el polinomio de Chebyshev de grado (n-1) y sus raices (vector fila)
function [p, r] = polinomio_Chebyshev(n)
  t(1) = 1
  t(2) = poly([0 1], 'x', 'c')
  
  for i = 3 : n+1
    t(i) = (poly([0 2], 'x', 'c') * t(i-1)) - t(i-2)
  end

  p = t(n+1)
  r = roots(p)'
endfunction
// CASOS DE PRUEBA:
// --> [p, r] = polinomio_Chebyshev(5)
//  r  = 
//   -0.7660444  
//    0.9396926  
//    0.5  
//   -0.1736482  
//  p  = 
//              2    3     4
//    1 +4x -12x  -8x  +16x 
// --> [p, r] = polinomio_Chebyshev(7)
//  r  = 
//   -0.885456  
//    0.9709418  
//    0.7485107  
//   -0.5680647  
//    0.3546049  
//   -0.1205367  
//  p  = 
//              2     3     4     5     6
//   -1 -6x +24x  +32x  -80x  -32x  +64x 

// Ejercicio 10
function y = dibujar_ejercicio10(p, f, x)
  plot(x, f(x) - horner(p, x))
  plot(x, horner(p, x), 'g')
  plot(x, f, 'r')
  a=gca();
  a.x_location = "origin";
  a.y_location = "origin";
  y = 0
endfunction
// --> [T, r] = polinomio_Chebyshev(4)
//  r  = 
//   -0.9238795   0.9238795  -0.3826834   0.3826834
//  T  = 
//         2    4
//    1 -8x  +8x 
// --> p = metodo_interpolacion_largrange(r, exp(r))
//  p  = 
// Real part
//                                     2            3
//    0.9946153 +0.9989332x +0.5429007x  +0.1751757x 
// Imaginary part 
//    0
// --> dibujar_ejercicio10(p, exp, [-1:0.1:1])
//  ans  =
//    0.

// Ejercicio 11
