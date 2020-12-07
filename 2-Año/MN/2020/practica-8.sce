// regla_del_trapecio :: (Float -> Float) Float Float -> Float
// Dada una funcion f y un intervalo [a, b]
// Aproxima el valor de la integral definida en el intervalo
function I = regla_del_trapecio(f, a, b)
  I = (f(a) + f(b))*(b - a)/2
endfunction
// CASOS DE PRUEBA:
// --> deff('y=f(x)', 'y=2*x^3')
// --> regla_del_trapecio(f, 0, 2)
//  ans  =
//    16.
// --> integrate('f(x)', 'x', 0, 2)
//  ans  =
//    8.

// regla_de_Simpson :: (Float -> Float) Float Float -> Float
function I = regla_de_Simpson(f, a, b)
  h = (b - a) / 2
  c = a + h
  I = (f(a) + 4*f(c) + f(b))*h/3
endfunction
// CASOS DE PRUEBA:
// --> deff('y=f(x)', 'y=2*x^3')
// --> regla_de_Simpson(f, 0, 2)
//  ans  =
//    8.
// --> integrate('f(x)', 'x', 0, 2)
//  ans  =
//    8.

// Ejercicio 1
// --> regla_del_trapecio(log, 1, 2)
//  ans  =
//    0.3465736
// --> regla_de_Simpson(log, 1, 2)
//  ans  =
//    0.3858346
// --> integrate('log(x)', 'x', 1, 2)   <-- Valor real
//  ans  =
//    0.3862944

// --> deff('y=g1(x)', 'y=x^(1/3)')
// --> regla_del_trapecio(g1, 0, .1)
//  ans  =
//    0.0232079
// --> regla_de_Simpson(g1, 0, .1)
//  ans  =
//    0.0322962
// --> integrate('g1(x)', 'x', 0, .1)   <-- Valor real
//  ans  =
//    0.0348119

// --> deff('y=g2(x)', 'y=(sin(x))^2')
// --> regla_del_trapecio(g2, 0, %pi/3)
//  ans  =
//    0.3926991
// --> regla_de_Simpson(g2, 0, %pi/3)
//  ans  =
//    0.3054326
// --> integrate('g2(x)', 'x', 0, %pi/3)   <-- Valor real
//  ans  =
//    0.3070924
// TODO: Hacer parte b) en papel

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

// regla_del_trapecio_compuesto :: (Float -> Float) Float Float Int -> Float
// Dada una funcion f, un intervalo [a, b] y un entero n
// Aproxima el valor de la integral de f en [a, b] con n subintervalos
function I = regla_del_trapecio_compuesto(f, a, b, n)
  h = (b - a) / n
  xi = a+h : h : b-h
  
  I = (sum(aplicar(f, xi)) + (f(a) + f(b)) / 2) * h
endfunction

// regla_de_Simpson_compuesto :: (Float -> Float) Float Float Int -> Float
// Dada una funcion f, un intervalo [a, b] y un entero n
// Aproxima el valor de la integral de f en [a, b] con n subintervalos
function I = regla_de_Simpson_compuesto(f, a, b, n)
  h = (b - a) / n
  par = a+2*h : 2*h : b-2*h
  impar = a+h : 2*h : b-h

  I = ((f(a)+f(b)) + 2*sum(aplicar(f, par)) + 4*sum(aplicar(f, impar))) * (h/3)
endfunction

// Ejercicio 2
function y = resolver_ejercicio2(f, a, b, n)
  I = regla_del_trapecio_compuesto(f, a, b, n)
  I_ = integrate('f(x)', 'x', a, b)

  printf("Regla del Trapecio Compuesto:")
  disp(I)
  printf("Integrate:")
  disp(I_)
  printf('Error')
  disp(abs(I_ - I))

  y = 0
endfunction

// --> deff('y=f(x)', 'y=1/x')
// --> resolver_ejercicio2(f, 1, 3, 4)
// Regla del Trapecio Compuesto:
//    1.1166667
// Integrate:
//    1.0986123
// Error
//    0.0180544
//  ans  =
//    0.

// --> deff('y=f(x)', 'y = x^3')
// --> resolver_ejercicio2(f, 0, 2, 4)
// Regla del Trapecio Compuesto:
//    4.25
// Integrate:
//    4.
// Error
//    0.25
//  ans  =
//    0.

// --> deff('y=f(x)', 'y = x * (1 + x^2)^(1/2)')
// --> resolver_ejercicio2(f, 0, 3, 6)
// Regla del Trapecio Compuesto:
//    10.312201
// Integrate:
//    10.207592
// Error
//    0.104609
//  ans  =
//    0.

// --> deff('y=f(x)', 'y=sin(%pi*x)')
// --> resolver_ejercicio2(f, 0, 1, 8)
// Regla del Trapecio Compuesto:
//    0.6284174
// Integrate:
//    0.6366198
// Error
//    0.0082023
//  ans  =
//    0.

// --> deff('y=f(x)', 'y = x*sin(x)')
// --> resolver_ejercicio2(f, 0, 2*%pi, 8)
// Regla del Trapecio Compuesto:
//   -5.9568332
// Integrate:
//   -6.2831853
// Error
//    0.3263521
//  ans  =
//    0.

// --> deff('y=f(x)', 'y = (x^2)*exp(x)')
// --> resolver_ejercicio2(f, 0, 1, 8)
// Regla del Trapecio Compuesto:
//    0.7288902
// Integrate:
//    0.7182818
// Error
//    0.0106083
//  ans  =
//    0.

// Ejercicio 3
function y = resolver_ejercicio3(f, a, b, n)
  I = regla_de_Simpson_compuesto(f, a, b, n)
  I_ = integrate('f(x)', 'x', a, b)

  printf("Regla de Simpson Compuesto:")
  disp(I)
  printf("Integrate:")
  disp(I_)
  printf('Error')
  disp(abs(I_ - I))

  y = 0
endfunction

// --> deff('y=f(x)', 'y=1/x')
// --> resolver_ejercicio3(f, 1, 3, 4)
// Regla de Simpson Compuesto:
//    1.1
// Integrate:
//    1.0986123
// Error
//    0.0013877
//  ans  =
//    0.

// --> deff('y=f(x)', 'y = x^3')
// --> resolver_ejercicio2(f, 0, 2, 4)
// Regla del Trapecio Compuesto:
//    4.25
// Integrate:
//    4.
// Error
//    0.25
//  ans  =
//    0.

// --> deff('y=f(x)', 'y = x * (1 + x^2)^(1/2)')
// --> resolver_ejercicio3(f, 0, 3, 6)
// Regla de Simpson Compuesto:
//    10.206346
// Integrate:
//    10.207592
// Error
//    0.0012459
//  ans  =
//    0.

// --> deff('y=f(x)', 'y=sin(%pi*x)')
// --> resolver_ejercicio3(f, 0, 1, 8)
// Regla de Simpson Compuesto:
//    0.6367055
// Integrate:
//    0.6366198
// Error
//    0.0000857
//  ans  =
//    0.

// --> deff('y=f(x)', 'y = x*sin(x)')
// --> resolver_ejercicio3(f, 0, 2*%pi, 8)
// Regla de Simpson Compuesto:
//   -6.2975102
// Integrate:
//   -6.2831853
// Error
//    0.0143249
//  ans  =
//    0.

// --> deff('y=f(x)', 'y = (x^2)*exp(x)')
// --> resolver_ejercicio3(f, 0, 1, 8)
// Regla de Simpson Compuesto:
//    0.7183215
// Integrate:
//    0.7182818
// Error
//    0.0000396
//  ans  =
//    0.

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

// regla_trapecio_extendido :: (Float -> Float) Float Float Float Float -> Float
function I = regla_trapecio_extendido(f, a, b, c, d)
  I = (f(c, a) + f(c, b) + f(d, a) + f(d, b))*((d-c)*(b-a))/4
endfunction
// CASOS DE PRUEBA:

// Ejercicio 5
// --> deff('z=g(x, y)', 'z=sin(x+y)')
// --> regla_trapecio_extendido(g, 0, 2, 0, 1)
//  ans  =
//    0.9459442


// Ejercicio 6
