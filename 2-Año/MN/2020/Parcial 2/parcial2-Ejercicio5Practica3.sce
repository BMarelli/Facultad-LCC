clc

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
// --> deff("y=h(x)", "y=sqrt(x)")
// --> metodo_punto_fijo(h, 0.63, 10^-8)
//  ans  =
//    1.

deff('y=g5(x)', 'y = 2^(x-1)')
// --> metodo_punto_fijo(g5, 0.5, 10^-8)
//  ans  =
//    1.
