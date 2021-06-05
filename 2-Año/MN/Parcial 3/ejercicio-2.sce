// aplicar :: (Float -> Float) [Float] -> [Float]
// Dada una funcion f y un vector x (n)
// Aplica f a cada elemento de x
// La utilizo si la funcion f tiene un dividido y hacer f(x) da un error
function y = aplicar(f, x)
  n = size(x, 2)
  y = zeros(1, n)
  for i = 1 : n
    y(i) = f(x(i))
  end
endfunction
// CASOS DE PRUEBA:
// --> deff('y=f(x)', 'y=4/x')
// --> aplicar(f, [1 2 3 4 5])
//  ans  =
//    4.   2.   1.3333333   1.   0.8


// regla_de_Simpson_compuesto :: (Float -> Float) Float Float Int -> Float
// Dada una funcion f, un intervalo [a, b] y un entero n
// Aproxima el valor de la integral de f en [a, b] con n subintervalos
function I = regla_de_Simpson_compuesto(f, a, b, n)
  h = (b - a) / n
  par = a+2*h : 2*h : b-2*h
  impar = a+h : 2*h : b-h

  I = ((f(a)+f(b)) + 2*sum(aplicar(f, par)) + 4*sum(aplicar(f, impar))) * (h/3)
endfunction
// CASOS DE PRUEBA:
// --> deff('y=f(x)', 'y=2*x^3')
// --> regla_de_Simpson_compuesto(f, 0, 2, 2)
//  ans  =
//    8.
// --> integrate('f(x)', 'x', 0, 2)
//  ans  =
//    8.

// --> deff('y=f(x)', 'y=2*sin(x/2)')
// --> regla_de_Simpson_compuesto(f, 0, %pi/2, 4)
//  ans  =
//    1.1715826
// --> regla_de_Simpson_compuesto(f, 0, %pi/2, 6)
//  ans  =
//    1.1715748
// --> integrate('f(x)', 'x', 0, %pi/2)
//   ans  =
//    1.1715729
function y = resolver_ejercicio()
  deff('y=f(x)', 'y=cos(2*(acos(x)))')
  I2 = regla_de_Simpson_compuesto(f, -1, 1, 2)
  I4 = regla_de_Simpson_compuesto(f, -1, 1, 4)
  I6 = regla_de_Simpson_compuesto(f, -1, 1, 6)
  printf("Regla de Simpson con 2 subintervalos:")
  disp(I2)
  printf("Regla de Simpson con 4 subintervalos:")
  disp(I4)
  printf("Regla de Simpson con 6 subintervalos:")
  disp(I6)

  y = 0
endfunction
// --> resolver_ejercicio()
// Regla de Simpson con 2 subintervalos:
//   -0.6666667
// Regla de Simpson con 4 subintervalos:
//   -0.6666667
// Regla de Simpson con 6 subintervalos:
//   -0.6666667
//  ans  =
//    0.

// Como sabemos por teoria, el metodo de Simpson aproxima la funcion con
// polinomios de grado 2 y luego calcula el area debajo de la curva
// En este caso, si graficamos:
// --> deff('y=f(x)', 'y=cos(2*(acos(x)))')
// --> x = [-1:.1:1];
// --> plot(x, f(x))
// Podemos ver que es una parabola, lo cual, polinomio de interpolacion
// coincide con la parabola (es unico) y de esta forma obtenemos en todos los
// casos los mismos resultados.
