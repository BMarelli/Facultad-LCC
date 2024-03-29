// Ejercicio 1
deff('y=f1(x)', 'y=1 + (cos(x) * ((exp(x) + exp(-x))/ 2))')
function y = dibujar(f, x)
  plot(x,f)
  a=gca();
  a.x_location = "origin";
  a.y_location = "origin";
  y = 0
endfunction

// CASOS DE PRUEBA:
// --> deff("y = h(x)", "y = 2*x - 2")
// --> dibujar(h, [-5:0.1:5])

// --> dibujar(f1, [0:0.1:8])
// Podemos ver que las primeras 3 raices positivas son apoximadamente:
// x1 = 1.875
// x2 = 4.6935
// x3 = 7.8523

// metodo_biseccion :: (Float -> Float) Float Float Float -> Float
// Dado una funcion y dos puntos (a y b / f(a) * f(b) < 0)
// calcula la raiz de f en el interbalo [a, b] con un error de e
function v = metodo_biseccion(f, a, b, e)
  if (f(a) * f(b)) >= 0 then
    v = %nan
  else
    c = (a + b) / 2
    while b - c > e then
      if (f(b) * f(c)) <= 0 then
        a = c
      else
        b = c
      end
      c = (a + b) / 2
    end

    v = c
  end
end

// CASOS DE PRUEBA:

// Ejercicio 2
// --> deff('y=g(x)', 'y = sin(x) - ((x^2)/2)')
// --> dibujar(g, [-1:0.1:2])
// --> metodo_biseccion(g, -1, 1, 10^-2)
//  ans  =
//    0.0078125
// --> metodo_biseccion(g, 1, 3, 10^-2)
//  ans  =
//    1.3984375

// --> deff('y=g(x)', 'y = exp(-x) - x^4')
// --> dibujar(g, [-9:0.1:1])
// --> metodo_biseccion(g, -2, -1, 10^-2)
//  ans  =
//   -1.4296875
// --> metodo_biseccion(g, -9, -5, 10^-2)
//  ans  =
//   -8.6171875
// --> metodo_biseccion(g, 0, 2, 10^-2)
//  ans  =
//    0.8203125

// --> deff('y=g(x)', 'y = x - 1 - log10(x)')
// --> plot([-1:0.1:2], g)
//--> metodo_biseccion(g, 0.1, 0.5, 10^-2)
//  ans  =
//    0.13125
// --> metodo_biseccion(g, 0.5, 1.5, 10^-2)
//  ans  =
//    1.0078125

// metodo_secante :: (Float -> Float) Float Float Float -> Float
// Dado una funcion y dos puntos (x0 y x1) calcula la raiz en el interbalo
// [x0, x1] con el metodo de la secante
function v = metodo_secante(f, x0, x1, e)
  while (abs(f(x1) - f(x0))) > e then
    xn = x1 - (f(x1) * ((x1 - x0) / (f(x1) - f(x0))))
    x0 = x1
    x1 = xn
  end

  v = xn
endfunction

// CASOS DE PRUEBA:

// Ejercicio 3
// --> deff('y=g(x)', 'y = ((x^2)/4) - sin(x)')
// --> metodo_secante(g, 1, 2, 10^-5)
//  ans  =
//    1.9337538

// Ejercicio 4
// Al aplicar varias veces cos a un valor x, vemos que esto converge a un valor
// aproximadamente: (Este es un punto fijo)
// --> cos(0)
//  ans  =
//    1.
//  ...
// --> cos(ans)
//  ans  =
//    0.7392822

// metodo_punto_fijo :: (Float -> Float) Float Float -> Float
// Dada una funcion f, un punto inicial x0 y una tolerancia de error e
// Calcula el valor v talque f(v) = v
function v = metodo_punto_fijo(f, x0, e)
  while abs(f(x0) - x0) > e then
    x0 = f(x0)
  end

  v = x0
endfunction

// CASOS DE PRUEBA:

// metodo_newton :: (Float -> Float) Float Float Int -> Float
// Dada una funcion f, un punto inicial x0, una tolerancia de error e y una
// cantidad maxima de iteraciones
// Calcula el valor v talque f(v) = 0
function v = metodo_newton(f, x0, e, iter)
  i = 0
  xn = x0 - (f(x0) / numderivative(f, x0))
  while (abs(xn - x0) > e) && (i < iter) then
    x0 = xn
    xn = x0 - (f(x0) / numderivative(f, x0))
    i = i + 1
  end

  v = xn
endfunction

// CASOS DE PRUEBA:

// Ejercicio 5
// Usamos el Teorema 2
// g (x) = 2 ^ (x - 1)
// Buscamos que g' (x) < 1 => x < 1.53
// Definimos a = -inf, b = 1.53
// Corroboramos que si -inf <= x <= 1.53 => -inf <= g (x) <= 1.53
// Por lo tanto, converge si partimos de un x < 1.53
// Luego como la solucion es unica, podemos obtener esta con:
deff('y=g5(x)', 'y = 2^(x-1)')
// --> metodo_punto_fijo(g5, 0.5, 10^-8)
//  ans  =
//    1.

// Ejercicio 6
// Sea a = -sqrt(5)
// Definimos g(x) = x + c * (x^2 - 5) => g'(x) = 1 + 2 * c * x
// g(x) y g'(x) son continuas en R.
// Luego g'(a) = 1 - 2 * c * sqrt(5) =>
// => |g'(a)| < 1 <==> 0 < c < 1 / sqrt(5)
// Luego tomando un c = 1 / (2 * sqrt(5)) < 1 / sqrt(5)
// podemos asegurar la convergencia

c = 1 / (2 * sqrt(5))
deff("y=f6(x)", "y=x + c * (x^2 - 5)")
// --> metodo_punto_fijo(f6, 0, 10^-8)
//  ans  =
//   -2.236068
// --> -sqrt(5)
//  ans  =
//   -2.236068


// Ejercicio 7
// a)
deff("y=onda(d)", "y=(4*(%pi)^2) / (25 * 9.8 * tanh(4*d))")
// --> metodo_punto_fijo(onda, 1, 10^-1)
//  ans  =
//    0.2835513

// b)
deff("y=g6(d)", "y=(4*(%pi)^2) / (25 * 9.8 * tanh(4*d)) - d")
// --> a = metodo_punto_fijo(onda, 1, 10^-1)
//  a  = 
//    0.2835513
// --> metodo_newton(g6, a, 10^-4, 200)
//  ans  =
//    0.2249735

// Ejercicio 8
deff("y=g1(x)", "y=exp(x) / 3")
// --> dibujar(g1, [-1:0.1:2])
// Podemos ver que 0 <= x <= 1, 0 <= g1(x) <= 1
// Luego g1'(x) < 1 en [0, 1]
// Podemos obtener la solucion con:
// --> metodo_punto_fijo(g1, 0, 10^-4)
//  ans  =
//    0.6188108

deff("y=g2(x)", "y=(exp(x) - x) / 2")
// --> deff("y=Dg2(x)", "y=(0.5)*(exp(x) - 1)")
// --> dibujar(g2, [0:0.1:2])
// Podemos ver que 0 <= x <= 1, 0 <= g2(x) <= 1
// Si hacemos dibujar(Dg2, [0:0.1:1]) vemos que Dg2 < 1 en [0, 1]
// Podemos obtener la solucion con:
// --> metodo_punto_fijo(g2, 0, 10^-4)
//  ans  =
//    0.618952

deff("y=g3(x)", "y=log(3*x)")
// --> dibujar(g3, [0:0.1:4])
// --> deff("y=Dg3(x)", "y=1/x")
// Podemos ver que para x <= 3.5, g3(x) <= 3.5
// Busquemos una cota inferior
// Vemos que 1.2 <= x <= 3.5, Dg3(x) < 1
// Ahora podemos obtener la solucion con:
// --> metodo_punto_fijo(g3, 1.2, 10^-4)
//  ans  =
//    1.511869

deff("y=g4(x)", "y=exp(x) - (2 * x)")
// --> deff("y=Dg4(x)", "y=exp(x) - 2")
// --> dibujar(g4, [0:0.1:4])
// Vemos que Dg4(x) < 1 si x <= 1.1
// Luego tambien vemos que, 0 <= x <= 1.1, 0 <= g4(x) <= 1.1
// Ahora podemos obtener el resultado con:
// --> metodo_punto_fijo(g4, 0, 10^-4)
//  ans  =
//    0.6190754

// Nos sirven todas. Podemos ver que  con g3, podemos calcular el punto 1.5118
// ya que trabajamos con un intervalo en el cual, el punto 0.6190 no pertenece

// metodo_newton_multivariable :: SistEcua [Int] Float Int -> Float
// Dado un sitema de ecuaciones F y un punto inicial x0,
// calcula el valor de x talque F(x) = 0 con un error de e
function v = metodo_newton_multivariable(F, x0, e, iter)
  J = numderivative(F, x0)
  i = 0
  if (det(J) <> 0) then
    // Tenemos que ver que la distancia de F(x0) sea lo mas cercano a e
    while (norm(F(x0)) > e) && (i < iter) then
      x0 = x0 - (inv(J) * F(x0))
      J = numderivative(F, x0)
      i = i + 1
    end
    v = x0
  else v = %nan
  end
endfunction

// CASOS DE PRUEBA:

// Ejercicio 9
function y = h1(x)
  y(1) = 1 + x(1)^2 - x(2)^ 2 + exp(x(1)) * cos(x(2))
  y(2) = (2 * x(1) * x(2)) + (exp(x(1)) * sin(x(2)))
endfunction

// --> metodo_newton_multivariable(h, [-1,4]', 10^-4, 5)
//  ans  =
//  -0.293178
//   1.1726344

// --> h(ans)
// ans  =
//   0.0000818
//  -0.0000389

// Ejercicio 10
function y = h2(x)
  y(1) = x(1)^2 + (x(1) * x(2)^3) - 9
  y(2) = (3 * x(1)^2 * x(2)) - 4 - x(2)^3
endfunction

// --> metodo_newton_multivariable(h2, [1.2, 2.5]', 10^-4, 200)
//  ans  =
//  1.3363554
//  1.7542352

// --> h2(ans)
// ans  =
// -5.174D-08
// -0.0000001

// --> metodo_newton_multivariable(h2, [-2, 2.5]', 10^-4, 200)
//  ans  =
//   -0.9012662
//   -2.0865876

// --> h2(ans)
//  ans  =
//    7.726D-10
//    1.821D-10

// --> metodo_newton_multivariable(h2, [-1.2, -2.5]', 10^-4, 200)
//  ans  =
//  -0.9012662
//  -2.0865876

// --> h2(ans)
// ans  =
//   1.092D-08
//  -1.480D-08

// --> metodo_newton_multivariable(h2, [-1.2, -2.5]', 10^-4, 200)
//  ans  =
//  -0.9012662
//  -2.0865876

// --> h2(ans)
// ans  =
//   1.092D-08
//  -1.480D-08

// minimo_locales :: SistEcua [Int] Float -> [[Int], Bool]
// Recibe la funcion derivada (a mano), un punto inicial y un error
// Calcula los minimos locales y lo devuelve:
// tipo = T : Es minimo local
// tipo = F : TODO: ?
function [v, tipo] = minimo_locales(DF, x0, e)
  v = metodo_newton_multivariable(DF, x0, e, 300)
  H = numderivative(DF, v)
  n = size(H, 1)
  rs = spec(H)
  bools = zeros(n, 1)

  for i = 1 : n
    bools(i) = rs(1) > 0
  end

  tipo = and(bools)
end

// Ejercicio 11
function y = f(x)
  y = 2 * x(1) + 3 * x(2)^2 + exp((2 * x(1)^2) + x(2)^2)
endfunction

function y = dF(x)
  y(1) = 2 + exp(2*x(1)^2 + x(2)^2) * 4*x(1)
  y(2) = 6 * x(2) + exp(2*x(1)^2 + x(2)^2) * 2*x(2)
endfunction

// --> [v, tipo] = minimo_locales(dF, [1,1]', 10^-12)
//  tipo  = 
//   T
//  v  = 
//   -0.3765446
//    2.640D-16


// TODO: Preguntar cuando es maximo o minimo
// minimo_maximo_locales :: SistEcua [Int] Float -> [[Int], Int]
// Recibe la funcion derivada (a mano), un punto inicial y un error
// Calcula los minimos/maximos locales y devuelve el tipo que es:
// 0 : Silla
// 1 : Minimo
// 2 : Maximo
// function [v, tipo] = minimo_maximos_locales(DF, x0, e)
//   v = metodo_newton_multivariable(DF, x0, e, 300)
//   H = numderivative(DF, x0)
//   n = size(v, 1)
//   determinantes = zeros(n, 0)
//   for (i = 1 : n)
//       determinantes(i) = det(H(1:i, 1:i)) > 0
//   end

//   if (and(determinantes))
//       tipo = 1
//   else
//       i = 1
//       while (i <= n) then
//           determinantes(i) = ~ determinantes(i)
//           i = i + 2
//       end
//       if (and(determinantes))
//           tipo = 2
//       else
//           tipo = 0
//       end
//   end
// endfunction

// --> [v, tipo] = minimo_maximos_locales(dF, [1,1]', 10^-12)
//  tipo  = 
//    1.
//  v  = 
//   -0.3765446
//    2.640D-16

// --> f(v)
//  ans  =
//    0.5747748

// Ejercicio 12
deff("y=f12(k, r)", "y=k(1) * exp(k(2) * r) + k(3) * r")

function v = sistema_12(k)
  v(1) = f12(k, 1) - 10
  v(2) = f12(k, 2) - 12
  v(3) = f12(k, 3) - 15
endfunction

// --> metodo_newton_multivariable(sistema_12, [2,2,2]', 10^-8, 300)
//  ans  =
//    8.7712864
//    0.2596954
//   -1.3722813

k = [8.7712864 0.2596954 -1.3722813]';
deff("r=g12(r)", "r=f12(k, r) - (500 / (%pi * r^2))")

// --> metodo_secante(g12, 1, 18, 10^-6)
//  ans  =
//    3.1851628
