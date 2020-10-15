// Calcula las raices de un polinomio de grado 2
// Para solucionar el problema de que b = 0
// calculamos hacemos la resolvente
function v = raices(p)
  // Obtenemos los coeficientes
  a = coeff(p, 2)
  b = coeff(p, 1)
  c = coeff(p, 0)
  // Calculamos el discriminante
  disc = b^2 - (4 * a * c)
  if (disc > 0) then
    // Obtenemos las raices segun el metodo robusto
    if b < 0 then
      v(1) = 2 * c / ((-b) + sqrt(disc))
      v(2) = (-b + sqrt(disc)) / (2 * a)
    elseif b > 0 then
        v(1) = (-b - sqrt(disc)) / (2 * a)
        v(2) = (2 * c) / ((-b) - sqrt(disc))
    else
      // Calculamos las raices con la resolvente (trabajamos un poco con la ecuacion)
      v(1) = (sqrt(-c*a)) / a
      v(2) = -(sqrt(-c*a)) / a
    end
  elseif disc == 0 then
    // Obtenemos la raiz doble
    r = - (b / (2 * a))
    v(1) = r
    v(2) = r
  else
    // Como no trabajamos con raices imaginarias, devolvemos %nan
    v(1) = %nan
    v(2) = %nan
  end
endfunction

// --> p = poly([-0.0001 10000.0 0.0001],"x","coeff");
// --> roots1 = raices(p);
// --> roots2 = roots(p);
// --> r1 = roots1(2);
// --> r2 = roots2(2);
// --> e1 = 1e-8;
// --> error1 = abs(r1-e1)/e1;
// --> error2 = abs(r2-e1)/e1;
// --> printf("raices : %e (error= %e)\n", r1, error1);
// raices : 1.000000e-08 (error= 0.000000e+00)
// --> printf("roots : %e (error= %e)\n", r2, error2);
// roots : 1.000000e-08 (error= 0.000000e+00)
