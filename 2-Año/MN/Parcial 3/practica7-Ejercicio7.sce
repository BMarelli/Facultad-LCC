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
// --> x = [0:.1:1];
// --> y = [0 0.01 .0345 .0105 .165 .23 .3 .5 .66 .871 1.15];
// --> p = metodo_minimos_cuadrados(x, y, 4)
//  p  = 
//                                     2            3            4
//    0.0051923 -0.1843075x +1.3692162x  -0.5575952x  +0.5142774x 
// Aproximacion de x^2

// Ejercicio 7
function v = resolver_ejercicio7()
  x = [0 .15 .31 .5 .6 .75]
  y = [1 1.004 1.31 1.117 1.223 1.422];
  p(1) = metodo_minimos_cuadrados(x, y, 1)
  p(2) = metodo_minimos_cuadrados(x, y, 2)
  p(3) = metodo_minimos_cuadrados(x, y, 3)

  for i = 1 : 3
    printf("Polinomion: ")
    disp(p(i))
    printf("Error: ")
    disp(sum(abs(horner(p(i), x) - y)))
  end

  v = 0
endfunction
// --> resolver_ejercicio7()
// Polinomion:                 
//    0.9960666 +0.4760174x
// Error: 
//    0.4784433
// Polinomion: 
//                                    2
//    1.007732 +0.3542987x +0.1635646x 
// Error: 
//    0.4665116
// Polinomion: 
//                                     2          3
//    0.9653196 +1.6154731x -4.3450249x  +3.97241x 
// Error: 
//    0.3821412
//  ans  =
//    0.
// Como podemos ver, el polinomio con menos error es el de grado 3, por lo que
// es la mejor opcion
