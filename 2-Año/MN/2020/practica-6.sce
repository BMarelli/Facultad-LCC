// CONSULTA: Ejemplo 8, pagina 7 apunte. Calcular circulos por filas, y columnas
// CONSULTA: Ver bien esto

// Ejercicio 1
// b)
a1 = [1 0 0; -1 0 1; -1 -1 2];
spec(a1)
// ans  =
//    1.  
//    1.  
//    1. 
b1 = [1 0 0; -0.1 0 0.1; -0.1 -0.1 2];
spec(b1)
// ans  =
//    1.9949874  
//    0.0050126  
//    1. 
c1 = [1 0 0; -0.25 0 0.25; -0.25 -0.25 2];
spec(c1)
//  ans  =
//    1.9682458  
//    0.0317542  
//    1. 
d1 = [4 -1 0; -1 4 -1; -1 -1 4];
spec(d1)
// ans  =
//    4.618034  
//    2.381966  
//    5.
e1 = [3 2 1; 2 3 0; 1 0 3];
spec(e1)
// ans  =
//    0.763932
//    3.
//    5.236068
f1 = [4.75 2.25 -0.25; 2.25 4.75 1.25; -0.25 1.25 4.75];
spec(f1)
// ans  =
//    2.0646374
//    4.9616991
//    7.2236635

// Ejercicio 3
// ejercicio3_obtener_poly_roots :: Float -> [Poly, [Float]]
// Dado un valor e
// Calcula el polinomio caracteristico de la matriz:
// A = [1 −1 0; −2 4 −2; 0 −1 (1+e)]
function [p, r] = ejercicio3_obtener_poly_roots(e)
  p = poly([(2*e) (-5 + (-5*e)) (6+e) -1], 'x', 'c')
  r = roots(p)
endfunction

// ejercicio3_resolver :: Int
// Muestra el resultado de ejecutar ejercicio3_obtener_poly_roots con los
// valores i = 0, ..., 10
function v = ejercicio3_resolver()
  for e = 0 : 10
    [p, r] = ejercicio3_obtener_poly_roots((.1 * e))
    A = [1 -1 0; -2 4 -2; 0 -1 (1+(.1 * e))];
    spc = spec(A)
    printf("Polinomio Caracteristico de e = %f", (.1*e))
    disp(p)
    printf("Autovalores - (Raices PC / spec)")
    disp(r)
    disp(spc)
    printf("\n")
  end

  v = 0
endfunction

// --> ejercicio3_resolver()
// Polinomio Caracteristico de e = 0.000000
//          2   3
//   -5x +6x  -x 
// Autovalores - (Raices PC / spec)
//    5.  
//    1.  
//    0.  

//    5.  
//    1.  
//    0.  

// Polinomio Caracteristico de e = 0.100000
//                   2   3
//    0.2 -5.5x +6.1x  -x 
// Autovalores - (Raices PC / spec)
//    5.0102088  
//    1.0518401  
//    0.0379511  

//    5.0102088  
//    0.0379511  
//    1.0518401  

// Polinomio Caracteristico de e = 0.200000
//                 2   3
//    0.4 -6x +6.2x  -x 
// Autovalores - (Raices PC / spec)
//    5.0208508  
//    1.1071946  
//    0.0719546  

//    5.0208508  
//    0.0719546  
//    1.1071946  

// Polinomio Caracteristico de e = 0.300000
//                   2   3
//    0.6 -6.5x +6.3x  -x 
// Autovalores - (Raices PC / spec)
//    5.0319506  
//    1.1657664  
//    0.102283  

//    5.0319506  
//    0.102283  
//    1.1657664  

// Polinomio Caracteristico de e = 0.400000
//                 2   3
//    0.8 -7x +6.4x  -x 
// Autovalores - (Raices PC / spec)
//    5.0435344  
//    1.2272145  
//    0.1292512  

//    5.0435344  
//    0.1292512  
//    1.2272145  

// Polinomio Caracteristico de e = 0.500000
//                 2   3
//    1 -7.5x +6.5x  -x 
// Autovalores - (Raices PC / spec)
//    5.0556299  
//    1.2911771  
//    0.153193  

//    5.0556299  
//    0.153193  
//    1.2911771  

// Polinomio Caracteristico de e = 0.600000
//                 2   3
//    1.2 -8x +6.6x  -x 
// Autovalores - (Raices PC / spec)
//    5.0682668  
//    1.3572923  
//    0.1744409  

//    5.0682668  
//    0.1744409  
//    1.3572923  

// Polinomio Caracteristico de e = 0.700000
//                   2   3
//    1.4 -8.5x +6.7x  -x 
// Autovalores - (Raices PC / spec)
//    5.0814764  
//    1.4252116  
//    0.193312  

//    5.0814764  
//    0.193312  
//    1.4252116  

// Polinomio Caracteristico de e = 0.800000
//                 2   3
//    1.6 -9x +6.8x  -x 
// Autovalores - (Raices PC / spec)
//    5.0952921  
//    1.4946092  
//    0.2100986  

//    5.0952921  
//    0.2100986  
//    1.4946092  

// Polinomio Caracteristico de e = 0.900000
//                   2   3
//    1.8 -9.5x +6.9x  -x 
// Autovalores - (Raices PC / spec)
//    5.1097493  
//    1.5651862  
//    0.2250644  

//    5.1097493  
//    0.2250644  
//    1.5651862  

// Polinomio Caracteristico de e = 1.000000
//              2   3
//    2 -10x +7x  -x 
// Autovalores - (Raices PC / spec)
//    5.1248854  
//    1.6366718  
//    0.2384428  

//    5.1248854  
//    0.2384428  
//    1.6366718  

//  ans  =
//    0.

// Ejercicio 4
// dibujar_circulo :: Float Float -> Int
// Dado un centro c y un radio r
// Dibuja una circunferencia de radio r y centro c
function y = dibujar_circulo(c, r)
  rect = [c-r,-r,c+r,r]
  p = 0
  xarc(c-r,r,2*r,2*r,0,360*64)
  plot2d(p,rect=rect)
  y = 0
endfunction
// CASOS DE PRUEBA:

// circulos_Gerschgorin :: [[Float]] -> Float
// Dada una matriz cuadrada A (n*n)
// Calcula los circulos de Gerschgorin y llama dibujar_circulo para plotearlos
// Tambien calcula los autovalores y los plotea con una +
// Devuelve los autovalores
function v = circulos_Gerschgorin(A)
  [nA, mA] = size(A)

  if nA<>mA then
    error('circulos_Gerschgorin - La matriz A debe ser cuadrada')
    abort
  end

  autovalores = spec(A)
  
  centros = diag(A)
  radio = sum(abs(A),'c') - abs(centros) ;
  c = max(centros)
  r = max(radio)
  rect = [c-r,-r,c+r,r]
  // plot2d(real(spec(A)),imag(spec(A)),-1,"032","", rect)
  scatter(real(spec(A)), imag(spec(A)))
  // xgrid(1) 
  for i = 1: nA
    dibujar_circulo(centros(i), radio(i))
  end

  v = autovalores
endfunction
// CASOS DE PRUEBA:


// FIXME:
// metodo_de_la_potencia :: [[Float]] [Float] -> [Float, [Float]]
// Dada una matriz cuadrada A (n*n) y un vector columna z0 (n)
// Calcula el maximo autovalor de A y su respectivo autovector
function [l, v, i] = metodo_de_la_potencia(A, z0)
  [nA, mA] = size(A)

  if nA<>mA then
    error('metodo_de_la_potencia - La matriz A debe ser cuadrada')
    abort
  end

  eps = 1e-10

  w = A * z0
  z = w / norm(w, "inf")
  [_, k] = max(abs(w))
  l = w(k) / z0(k)

  i = 1
  while norm(z - z0) > eps
    z0 = z
    w = A * z0
    z = w / norm(w, "inf")
    [wk, k] = max(abs(w))
    l = w(k) / z0(k)
    i = i + 1
  end

  v = z
endfunction
// CASOS DE PRUEBA:

// Ejercicio 5
// --> A = [6 4 4 1; 4 6 1 4; 4 1 6 4; 1 4 4 6];
// --> [l, v, i] = metodo_de_la_potencia(A, [1 2 3 4]')
//  i  = 
//    22.
//  v  = 
//    1.
//    1.
//    1.
//    1.
//  l  = 
//    15.

// --> A = [12 1 3 4; 1 -3 1 5; 3 1 6 -2; 4 5 -2 -1];
// --> [l, v] = metodo_de_la_potencia(A, [1 0 0 0]')
//    37.  --> Cantidad de iteraciones
//  v  = 
//    1.
//    0.1558606
//    0.3183534
//    0.2725212
//  l  = 
//    14.201006

// TODO: b) No lo entiendo xd
// ejercicio5b_resolver :: [[Float]] [Float] -> [Float, [Float]]
// Dada una matriz cuadrada A (n*n) y un vector columna z (n)
// Calcula el maximo autovalor de A y su respectivo autovector
// Muestra la cantidad de iteraciones realizadas y el error de calculo
function [l, v, d] = ejercicio5b_resolver(A, z0)
  [nA, mA] = size(A)

  if nA<>mA then
    error('metodo_de_la_potencia - La matriz A debe ser cuadrada')
    abort
  end

  eps = 1e-10

  spc = spec(A)
  [_, k] = max(abs(spc))
  spc_max = spc(k)

  w = A * z0
  z = w / norm(w, "inf")
  [_, k] = max(abs(w))
  l = w(k) / z0(k)
  
  i = 1
  printf("(iteracion:%d) Error: ", i)
  d(1) = abs(spc_max - l)
  disp(d(1))

  while norm(z - z0) > eps
    z0 = z
    w = A * z0
    z = w / norm(w, "inf")
    [wk, k] = max(abs(w))
    l = w(k) / z0(k)
    i = i + 1
    printf("(iteracion:%d) Error: ", i)
    d(i) = abs(spc_max - l)
    disp(d(i))
  end

  plot([1:i], d(1:i)')

  v = z
endfunction
