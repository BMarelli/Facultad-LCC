// aplicar :: (Float -> Float) [Float] -> [Float]
// Dada una funcion f y un vector x (n)
// Aplica f a cada elemento de x
// La utilizo si la funcion f tiene un dividido y hacer f(x) da un error
function y = aplicar(f, x)
  for i = 1 : size(x, 2)
    y(i) = f(x(i))
  end
endfunction
// CASOS DE PRUEBA:
// --> deff('y=f(x)', 'y=4/x')
// --> aplicar(f, [1 2 3 4 5])
//  ans  =
//    4.   2.   1.3333333   1.   0.8

// regla_del_trapecio_compuesto :: (Float -> Float) Float Float Int -> Float
// Dada una funcion f, un intervalo [a, b] y un entero n
// Aproxima el valor de la integral de f en [a, b] con n subintervalos
function I = regla_del_trapecio_compuesto(f, a, b, n)
  h = (b - a) / n
  xi = a+h : h : b-h
  
  I = (sum(aplicar(f, xi)) + (f(a) + f(b)) / 2) * h
endfunction
// CASOS DE PRUEBA:
// --> deff('y=f(x)', 'y=2*x^3')
// --> regla_del_trapecio_compuesto(f, 0, 2, 2)
//  ans  =
//    10.
// --> regla_del_trapecio_compuesto(f, 0, 2, 6)
//  ans  =
//    8.2222222
// --> integrate('f(x)', 'x', 0, 2)
//  ans  =
//    8.

// regla_de_Simpson_compuesto :: (Float -> Float) Float Float Int -> Float
// Dada una funcion f, un intervalo [a, b] y un entero n
// Aproxima el valor de la integral de f en [a, b] con n subintervalos
function I = regla_de_Simpson_compuesto(f, a, b, n)
  h = (b - a) / n
  par = a+2*h : 2*h : b-2*h
  impar = a+h : 2*h : b-h

  I = ((f(a)+f(b)) + 2*sum(aplicar(f, par)) + 4*sum(aplicar(f, impar))) * (h/3)
endfunction
// --> deff('y=f(x)', 'y=2*x^3')
// --> regla_de_Simpson_compuesto(f, 0, 2, 2)
//  ans  =
//    8.
// --> regla_de_Simpson_compuesto(f, 0, 2, 6)
//  ans  =
//    8.
// --> integrate('f(x)', 'x', 0, 2)
//  ans  =
//    8.

// Ejercicio 4
function y = resolver_ejercicio4()
  deff('y=f(x)', 'y=(x+1)^(-1)')
  I1 = regla_del_trapecio_compuesto(f, 0, 1.5, 10)
  I2 = regla_de_Simpson_compuesto(f, 0, 1.5, 10)
  I = 0.9262907

  printf("Valor real:")
  disp(I)
  printf("Regla del Trapecio Compuesto:")
  disp(I1)
  printf('Error')
  disp(abs(I - I1))

  printf("Regla de Simpson Compuesto:")
  disp(I2)
  printf('Error')
  disp(abs(I - I2))

  y = 0
endfunction
// --> resolver_ejercicio4()
// Valor real:
//    0.9262907
// Regla del Trapecio Compuesto:
//    0.9178617
// Error
//    0.008429
// Regla de Simpson Compuesto:
//    0.9163064
// Error
//    0.0099843
//  ans  =
//    0.
