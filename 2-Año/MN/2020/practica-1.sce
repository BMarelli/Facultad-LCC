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
