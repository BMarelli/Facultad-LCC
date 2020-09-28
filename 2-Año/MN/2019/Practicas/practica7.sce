// NOTE: Lagrange recibe n puntos => poly grado n-1

// Metodo de Interpolacion de Lagrange

// metodo_interpol_lagrange: x y -> poly
// Recibe los puntos x-y y devueleve un polinomio que interpola dichos puntos.

function p = metodo_interpol_lagrange(x, y) // x, y son vectores fila!
  n = size(x, 2)
  c = 0
  for k = 1 : n
    _x = [x(1:k-1) x(k+1:n)]
    L(k) = poly([x(1:k-1) x(k+1:n)], "x", "r")
    L(k) = L(k) / horner(L(k), x(k))
  end
  p = 0
  for k = 1 : n
    p = p + L(k) * y(k)
  end
endfunction

// Metodo de Interpolacion de Newton: no anda

// Halla los coeficientes ai para el método de interpolación de Newton.

// function an = hallar_coeficiente_n(x, y, n)
//   if(n == 1) then
//     an = y(1)
//   else
//     an = ((y(n) - y(1)) / (x(n) - x(1)) - hallar_coeficiente_n(x, y, n-1)) / (x(n) - x(n-1))
//   end
// endfunction

// // Devuelve el polinomio de grado n-1 que interpola a los n puntos x,y dados.

// function p = metodo_interpol_newton(x, y, N)
//   if(N == 1) then
//     a0 = hallar_coeficiente_n(x, y, 1)
//     a1 = hallar_coeficiente_n(x, y, 2)
//     p = poly(x(1), "x", "r") * a1
//     p = p + a0
//   else
//     an = hallar_coeficiente_n(x, y, N)
//     p = poly([x(1:N-1)], "x", "r") * an
//     p = p + metodo_interpol_newton(x, y, N - 1)
//   end
// endfunction

// Metodo de interpolacion de Newton que anda

function z = diferenciaDividida(x,y)
  [Xn,Xm] = size(x)
  if Xm == 1 then
      z = y(1)
  else
      z =((diferenciaDividida(x(2:Xm),y(2:Xm))-diferenciaDividida(x(1:Xm-1),y(1:Xm-1))) / (x(Xm)-x(1)))
  end
endfunction

function z = interpolNewton(x,y)
  [Xm,Xn] = size(x)
  z= 0
  for k = 1:Xn
      pol = 1
      for j = 1:k-1
          pol = poly(x(1:j),"x","roots")
      end
      //disp(pol)
      dif = diferenciaDividida(x(1:k),y(1:k))
     //disp(dif)
    dif = dif*pol
    z = z + dif
  end
endfunction

// Dado un intervalo [a, b], un n y una función f, devuelve n+1 nodos
// equidistantes en el intervalo [a, b]

function [x, y] = obtener_nodos_equid(n, a, b, f)
    h = (b - a)/n
    for i = 1 : n + 1
        x(i) = a + (i-1) * h
        y(i) = f(x(i))
    end
endfunction

// Dada una serie de puntos x,y devuelve una función f que se aproxima a los puntos dados.

function f = minimos_cuadrados(x, y, gr) // Especificamos de que grado queremos que sea el
                                        // polinomio de aproximación 
     n = size(x, 2)
     A = zeros(n, gr)
     // Creamos la matriz A. (nuestras funciones son 
     // los polinomios: 1, x, x², x³, x⁴,...)
     for col = 1 : gr + 1
         for fil = 1 : n
             A(fil, col) = x(fil)^(col - 1)
         end
     end
     // Hallamos los coeficientes aplicando la fórmula.
     At = A'
     coef = (At * A) \ (At * y') // hacer más eficiente gg
     // Armamos la función
     f = poly(coef', "x", "c")
     
endfunction

// Metodo minimos cuadrados para funciones generales (hecho para dos funciones
// en caso de que falten mas agregar mas argumentos y modificar la funcion)

// x,y vectores fila


function coef = minimosCuadrados_gen(x, y, f1, f2)
  m = size(x, 2)
  A = zeros(m, 2)
  for fila = 1 : m
    A(fila, 1) = f1(x(fila))
    A(fila, 2) = f2(x(fila)) 
  end
  disp(A)
  At = A'
  coef = (At * A) \ (At * y')
endfunction

// Dado un intervalo [a, b], una función f y un conj de n puntos (x,y)
// grafica la funcion f y marca los n puntos (x,y)

function [] = grafica_funcion(a, b, f, x, y)
  n = size(x, 2)
  vec = [a: 0.01: b]
  plot2d(vec, f(vec))
  xset("color", 2)
  xgrid(3)
  for i = 1 : n
    plot2d(x(i), y(i), -9)
  end
endfunction

// Realiza una grafica de la aproximación de los puntos 
// (xi, yi) por mínimos cuadrados.

function [] = grafica_min_cuadrados(p, x, y)
    n = size(x, 2)
    plot2d(x, horner(p, x))
    xset("color", 2)
    xgrid(3) 
    for i = 1 : n
        plot2d(x(i), y(i), -9)
    end
endfunction

// Dado un n calcula el polinomio de Chebyshev de grado n correspondiente.

function p = polinomio_chebyshev(N)
  if (N == 0) then
    p = poly([1], "x", "c")
  elseif (N == 1) then
    p = poly([0 1], "x", "c")
  else
    p_ = poly([0 2], "x", "c")
    p = (p_ .* polinomio_chebyshev(N-1)) - polinomio_chebyshev(N-2)
  end
endfunction

// Dado un n, devuelve las n raíces del polinomio de Chebyshev.

function raices = nodos_chebyshev(n)
  for i = 1 : n
    raices(i) = cos((%pi/2) * ((2*i - 1) / n))
  end
endfunction

// Reindeaxar funcion: ejercicio 11

function x = x_indexada(a, b, x)
    t = ((b +a) + x*(b - a))/2
    x = t
endfunction

function p = p_indexado(g, a, b, X, gr) // roots de chebyshev
    n = size(X, 2)
    for i = 1 : n
        x(i) = x_indexada(a, b, X(i))
        y(i) = g(x(i))
    end
    p = metodo_interpol_newton(x, y, gr) //elegir newton o lagrange segun corresponda
endfunction


