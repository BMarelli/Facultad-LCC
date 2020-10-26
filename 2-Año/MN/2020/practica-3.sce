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
// --> deff('y=g(x)', 'y = ((x^2)/4) - sin(x)')
// --> metodo_biseccion(g, 1, 2, 10^-5)
//  ans  =
//    1.933754

// Ejercicio 4
// Al aplicar varias veces cos a un valor x, vemos que esto converge a un valor
// aproximadamente:
// --> cos(ans)
//  ans  =
//    0.7392822

function v = metodo_punto_fijo(f, x0, e)
  while abs(f(x0) - x0) > e then
    x0 = f(x0)
  end

  v = x0
endfunction

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
