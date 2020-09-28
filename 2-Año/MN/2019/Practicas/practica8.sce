// Ejecutar todas las funciones just in case

// Comandos: intg, integrate

// Regla del trapecio.

// Dada una función f y un intervalo [a, b] aproxima la integral
// de f entre a y b.

// Error del método: -(h^3/12) * f''(c) (h = b-a)

function I = regla_trapecio(a, b, f)
    I = (f(a) + f(b)) * (b - a)/2
endfunction

// Regla de Simpson

// Error del método: (-h^5)/90 * f⁴(c), c en [a, b],  h = (b-a)/2 

function I = regla_simpson(a, b, f) // verificar paridad
    h = (b-a)/2
    x0 = a
    x1 = a + h
    x2 = b
    I = (h/3) * [f(x0) + 4*f(x1) + f(x2)]
endfunction

// Método compuesto del trapecio: aproxima una integral dividiendo el 
// intervalo [a, b] en n subintervalos y aproxima la integral con la regla 
// del trapecio en cada uno de esos intervalos.

function I = metodo_trapecio(a, b, f, n)
    h = (b-a)/n
    I = (1/2) * f(a) + (1/2) * f(b)
    for j = 1 : n - 1
        I = I + f(a + j*h)
    end
    I = h * I
endfunction

// Método compuesto de Simpson. (verificar paridad)

function I = metodo_simpson(a, b, f, n)
  h = (b-a)/n
  I = f(a) + f(b)
  for j = 1 : n - 1
    if((modulo(j, 2) <> 0)) then
      I = I + 4*f(a + j*h)
    else 
      I = I + 2*f(a + j*h)
    end
  end
  I = (h/3) * I         
endfunction

// Método del trapecio para integrales dobles.

// Función auxiliar, aplica la fórmula del trapecio en funciones de
// dos variables. 
function I = metodo_trapecio2(a, b, f, n, x)
  h = (b-a)/n
  I = (1/2) * f(x, a) + (1/2) * f(x, b)
  for j = 1 : n - 1
      I = I + f(x, a + j*h)
  end
  I = h * I
endfunction

deff("y=f(x,y)","y=sin(x+y)")
deff("y=c(x)","y=0")
deff("y=d(x)","y=1")

// La integral es de la forma dxdy con f(x, y)
// n-->intervalos de x, m-->intervalos de y

function I = trapecio_doble(f, a, b, c, d, n, m)
  hy = (b - a)/m
  // Resuelvo la integral de adentro fijando el y 
  for i = 1 : m + 1
    yi = a + hy * (i-1)
    G(i) = metodo_trapecio_(c(yi), d(yi), f, n, yi)
  end
  // Luego resuelvo aplicando la fórmula del trapecio.
  I = (1/2) * G(1) + (1/2) * G(m+1)
  for j = 2 : m
      I = I + G(j)
  end
  I = hy * I 
endfunction

// Simpson integrales dobles.


// Método compuesto de Simpson para funciones de dos variables.
// El parámetro x es un auxiliar que utilizamos en la funcion simpson_doble
function I = metodo_simpson2(a, b, f, n, x)
  
  h = (b-a)/n
  I = f(x, a) + f(x, b)
  for j = 1 : n - 1
    if((modulo(j, 2) <> 0)) then
      I = I + 4*f(x, a + j*h)
    else 
      I = I + 2*f(x, a + j*h)
    end
  end
  I = (h/3) * I         
endfunction

// La integral es de la forma dxdy con f(x, y)
// n-->intervalos de x, m-->intervalos de y
function I = simpson_doble(f, a, b, c, d, n, m)
  hy = (b - a)/m
  // Resuelvo la integral de adentro fijando el y 
  for i = 1 : m + 1
    yi = a + hy * (i-1)
    G(i) = metodo_simpson2(c(yi), d(yi), f, n, yi)
  end
  // Luego sólo queda aplicar la fórmula de Simpson.
  I = G(1) + G(m+1)
  for j = 2 : m
    if((modulo(j, 2) <> 0)) then
      I = I + 4*G(j)
    else 
      I = I + 2*G(j)
    end
  end
  I = (hy/3) * I         
endfunction
