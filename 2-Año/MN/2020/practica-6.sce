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
// Polinomio Caracteristico de e = 0
//          2   3
//   -5x +6x  -x 
// Autovalores - (Raices PC / spec)
//    5.  
//    1.  
//    0.  

//    5.  
//    1.  
//    0.  

// Polinomio Caracteristico de e = 1
//              2   3
//    2 -10x +7x  -x 
// Autovalores - (Raices PC / spec)
//    5.1248854  
//    1.6366718  
//    0.2384428  

//    5.1248854  
//    0.2384428  
//    1.6366718  

// Polinomio Caracteristico de e = 2
//              2   3
//    4 -15x +8x  -x 
// Autovalores - (Raices PC / spec)
//    5.3234043  
//    2.3579264  
//    0.3186694  

//    5.3234043  
//    0.3186694  
//    2.3579264  

// Polinomio Caracteristico de e = 3
//              2   3
//    6 -20x +9x  -x 
// Autovalores - (Raices PC / spec)
//    5.6457513  
//    3.  
//    0.3542487  

//    0.3542487  
//    3.  
//    5.6457513  

// Polinomio Caracteristico de e = 4
//               2   3
//    8 -25x +10x  -x 
// Autovalores - (Raices PC / spec)
//    6.1413361  
//    3.484862  
//    0.3738019  

//    0.3738019  
//    3.484862  
//    6.1413361  

// Polinomio Caracteristico de e = 5
//                2   3
//    10 -30x +11x  -x 
// Autovalores - (Raices PC / spec)
//    6.810821  
//    3.8031132  
//    0.3860658  

//    0.3860658  
//    3.8031132  
//    6.810821  

// Polinomio Caracteristico de e = 6
//                2   3
//    12 -35x +12x  -x 
// Autovalores - (Raices PC / spec)
//    7.6055513  
//    4.  
//    0.3944487  

//    0.3944487  
//    4.  
//    7.6055513  

// Polinomio Caracteristico de e = 7
//                2   3
//    14 -40x +13x  -x 
// Autovalores - (Raices PC / spec)
//    8.4753118  
//    4.1241562  
//    0.400532  

//    0.400532  
//    4.1241562  
//    8.4753118  

// Polinomio Caracteristico de e = 8
//                2   3
//    16 -45x +14x  -x 
// Autovalores - (Raices PC / spec)
//    9.3883549  
//    4.2065011  
//    0.4051441  

//    0.4051441  
//    4.2065011  
//    9.3883549  

// Polinomio Caracteristico de e = 9
//                2   3
//    18 -50x +15x  -x 
// Autovalores - (Raices PC / spec)
//    10.327185  
//    4.2640561  
//    0.4087593  

//    0.4087593  
//    4.2640561  
//    10.327185  

// Polinomio Caracteristico de e = 10
//                2   3
//    20 -55x +16x  -x 
// Autovalores - (Raices PC / spec)
//    11.28218  
//    4.3061512  
//    0.4116685  

//    0.4116685  
//    4.3061512  
//    11.28218  
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
// Calcula los circulos de Gershgorin y llama dibujar_circulo para plotearlos
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
  plot2d(real(spec(A)),imag(spec(A)),-1,"032","", rect)
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
  // elseif A <> A' then
  //   error('metodo_de_la_potencia - La matriz A debe ser simetrica')
  //   abort
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
function [l, v] = ejercicio5b_resolver(A, z0)
  [nA, mA] = size(A)

  if nA<>mA then
    error('ejercicio5b_resolver - La matriz A debe ser cuadrada')
    abort
  end

  [l, v, i] = metodo_de_la_potencia(A, z0)
  spc = spec(A)
  [_, k] = max(abs(spc))
  spc_max = spc(k)

  printf("Cantidad de iteraciones: ")
  disp(i)
  
  printf("Error: ")
  disp(abs(spc_max - l))
endfunction
