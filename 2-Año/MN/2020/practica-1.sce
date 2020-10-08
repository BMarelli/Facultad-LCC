// Calcula las raices de un polinomio de grado 2
// Para solucionar el problema de que b = 0
// calculamos hacemos la resolvente
function v = raices(p)
  a = coeff(p, 0)
  b = coeff(p, 1)
  c = coeff(p, 2)
  if (b^2 - 4 * a * c > 0) then
    if b < 0 then
      v(1) = 2 * c / (-b) + sqrt(b^2 - 4 * a * c)
      v(2) = (-b + sqrt(b^2 - 4 * a * c)) / 2 * a
    elseif b > 0 then
        v(1) = (-b - sqrt(b^2 - 4 * a * c)) / 2 * a
        v(2) = 2 * c / (-b) - sqrt(b^2 - 4 * a * c)
    else
      v(1) = (sqrt(-c*a))
      v(2) = -(sqrt(-c*a))
    end
  else
    v = %nan
  end
endfunction

// Evalua x0 en p de forma recursiva
// Horner(0, p, x0)
function v = Horner(N, p, x0)
  n = degree(p)
  if n == N then
    v = coeff(p, n)
  else
    v = coeff(p, N) + x0 * Horner(N+1, p, x0)
  end
endfunction

// Calcula la n-esima derivada de f(x)
// Como es recursiva, consume mucha memoria
function v = derivada(n, f, h, x)
  if n == 0 then
    v = f(x)
  else
    v = (derivada(n-1, f, h, x+h) - derivada(n-1, f, h, x)) / h
  end
endfunction

function v = derivada_iterativa(n, f, h, x)
  deff("y = Df0(x)", "y = f(x)")
  for i = 1 : n
    deff("y = Df"+string(i)+"(x)", "y = (Df"+string(i-1)+"(x+h) - Df"+string(i-1)+"(x)) / h")
  end
  deff("y = Dfn(x)", "y = (Df"+string(n - 1)+"(x+h) - Df"+string(n-1)+"(x)) / h")
  v = Dfn(x)
endfunction

function v = taylor(n, f, a, x, e)
  if n == 0 then
    v = f(x)
  else
    v = (derivada(n, f, e, a) * (x - a)^n) / factorial(n)
  end
endfunction

