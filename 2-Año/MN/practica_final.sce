// Ejercicio 2
//0.9222 * 10^4 + 0.9123 * 10^3 + 0.3244 * 10^3 + 0.2849 * 10^3
// Suma real = 9222 + 912.3 + 324.4 + 284.9 = 10743.6

// Suma mayor a menor:
// s1 = 0.9222 * 10^4
// s2 = s1 + 0.0912 * 10^4
//    = 1.0134 * 10^4
// s3 = s2 + 0.0324 * 10^4
//    = 1.0458 * 10^4
// s4 = s3 + 0.0284 * 10^4
//    = 1.0742 * 10^4 => 10742.0
// Er = | 10743.6 - 10742.0| / |10743.6| = 0.00014

// Suma menor a mayor:
// s1 = 0.2849 * 10^3
// s2 = s1 + 0.3244 * 10^3
//    = 0.6093 * 10^3
// s3 = s2 + 0.9123 * 10^3
//    = 1.5216 * 10^3
// s4 = s3 + 9.2220 * 10^3
//    = 10.7436 * 10^3 => 10743.6
// Er = | 10743.6 - 10743.6| / |10743.6| = 0

// Ejercicio 3

// b)
function v = Horner(p, x0, n)
  gr = degree(p)
  if n == gr then
    v = coeff(p, n)
  else
      v = coeff(p, n) + x0 * Horner(p, x0, n+1)
  end
endfunction

// Ejercicio 4
function v = derivar(f, x0, n, h)
  if n == 0 then
    v = f(x0)
  else
    v = (derivar(f, x0+h, n-1, h) - derivar(f, x0, n-1, h)) / h
  end
endfunction

function v = derivar_iterativa(f, x0, n, h)
  deff("y = Df0(x)", "y = f(x)")
  for i = 1 : n
    deff("y = Df"+string(i)+"(x)", "y = (Df"+string(i-1)+"(x+h) - Df"+string(i-1)+"(x)) / h")
  end
  deff("y = Dfn(x)", "y = (Df"+string(n - 1)+"(x+h) - Df"+string(n-1)+"(x)) / h")
  v = Dfn(x0)
endfunction

function v = taylor_iterativo(f, x0, a, n, h)
  v = f(a)
  for i=1:n
    v = v + (1/factorial(i)) * derivar_iterativa(f, a, i, h) * (x0-a)^i
  end
endfunction
