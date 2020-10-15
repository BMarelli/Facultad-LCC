// Calcula las raices de un polinomio de grado 2
// Para solucionar el problema de que b = 0
// calculamos hacemos la resolvente
function v = raices(p)
  a = coeff(p, 2)
  b = coeff(p, 1)
  c = coeff(p, 0)
  disc = b^2 - (4 * a * c)
  if (disc > 0) then
    if b < 0 then
      v(1) = 2 * c / ((-b) + sqrt(disc))
      v(2) = (-b + sqrt(disc)) / (2 * a)
    elseif b > 0 then
        v(1) = (-b - sqrt(disc)) / (2 * a)
        v(2) = (2 * c) / ((-b) - sqrt(disc))
    else
      v(1) = (sqrt(-c*a)) / a
      v(2) = -(sqrt(-c*a)) / a
    end
  elseif disc == 0 then
    r = - (b / (2 * a))
    v(1) = r
    v(2) = r
  else
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

function v = HornerIterativo(p, x0)
  n = degree(p)
  bn = coeff(p, n)
  bi = 0

  for i = (n - 1) : -1 : 0
    bi = coeff(p, i)
    bn = bi + (x0 * bn)
  end
  v = bn
end

// Calcula p(x0) y p'(x0)
// function v = Horner_Derivada(N, p, x0)
//   n = degree(p)
//   if n == N then
//     bn = coeff(p, n)
//     v(1) = bn
//     v(2) = bn * (x0^(n - 1))
//   else
//     an = coeff(p, N)
//     bn = Horner_Derivada(N+1, p, x0)
//     v(1) = an + (x0 * bn(1))
//     v(2) = v(1) + (bn(1) * (x0^(N - 1)))
//   end
// endfunction

function v = HornerIterativo_Derivada(p, x0)
  n = degree(p)
  bn = coeff(p, n)
  bi = 0
  di = 0

  for i = (n - 1) : -1 : 0
    di = di + (bn * (x0 ^ i))
    bi = coeff(p, i)
    bn = bi + (x0 * bn)
  end
  v(1) = bn
  v(2) = di
endfunction

// Calcula la n-esima derivada de f(x)
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
    v = f(a)
  else
    k = ((derivada(n, f, e, a) * ((x - a) ^ n)) / factorial(n))
    v = k + taylor(n-1, f, a, x, e)
  end
endfunction

function v = taylor_iterativa(n, f, a, x, e)
  v = f(a)
  for i = 1:n
    v = v + ((derivada_iterativa(i, f, e, a) * ((x - a) ^ i)) / factorial(i))
  end
endfunction

// Evalua el Polinomio de Taylor de la funcion exp(x) centrada en a = 0 en el
// punto x0
function v = exp_taylor(n, x0)
  // Calculamos los coeficientes de Tn
  orden = [0:n]
  c = factorial(orden)
  c = 1 ./ c
  // Creamos el polinomio Tn
  tn = poly(c, 'x', 'c')
  // Evaluamos el polinomio en el punto x0
  v = HornerIterativo(tn, x0)
endfunction

// (a)
// --> exp(-2)
//  ans  =
//    0.1353352832366127023178

// --> exp_taylor(10, -2)
//  ans  =
//    0.1353791887125219695065

// Si redondeamos a 3 digitos nos queda:
// exp(-2) = 0.135
// exp_taylor(10, -2) = 0.135

// (b)
// --> vr = exp(-2)
//  vr  = 
//    0.1353352832366127023178

// --> va1 = exp_taylor(10, -2)
//  va1  = 
//    0.1353791887125219695065

// --> va2 = exp_taylor(10, 2)
//  va2  = 
//    7.3889947089947085601125

// --> va2 = 1 / va2
//  va2  = 
//    0.1353364076418526185108

// --> error1 = abs(vr - va1) / vr
//  error1  = 
//    0.0003244200245438234225

// --> error2 = abs(vr - va2) / vr
//  error2  = 
//    0.000008308293395672326

// Como podemos ver, error2 < error1 y con esto podemos decir que va2 es la
// mejor aproximacion
