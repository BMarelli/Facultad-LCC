// minimos_cuadrados_ejercicio :: [Float] [Float] -> [Float]
function a = minimos_cuadrados_ejercicio(x, y)
  [_, n] = size(x)
  A = zeros(n, 2)
  // Creamos la matriz A. (nuestras funciones son
  // x
  // 1
  for i = 1:n
      A(i, 1) = x(i)
      A(i, 2) = 1
  end
  
  a = (A' * A) \ (A' * y')
endfunction

function v = resolver_ejercicio()
  x = [0:.4:8];
  y = [10.61 14.89 11.50 -4.58 13.65 23.47 24.29 23.33 22.80 45.03 25.85 46.46 40.84 65.5 75.96 79.91 93.19 126.21 147.4 158.78 193.23];

  a = minimos_cuadrados_ejercicio(x, log(y))
  a1 = a(1) 
  a2 = exp(a(2))

  plot(x, y)
  deff('y=g(x)', 'y=a2*exp(a1*x)')
  plot(x, g(x), 'm')
  v=0
endfunction

// Como podemos ver, la funcion nos quedo como una curva (magenta), la cual
// parece ser una buena aproximacion ya que en algunos casos si tenemos error
// pero tenemos que acordarnos de que los puntos obtenidos en las tablas son
// aproximaciones, las cuales ya tiene un error incluido.
// Ademas, al trabajar con minimos cuadrados, lo que hacemos es aproximar los
// puntos que tenemos con una funcion, lo cual agrega mas error.
// Como conclusion, en mi opinion, la curva parece ser una buena aproximacion
// de la funcion que buscamos.
