clc
// dibujar :: Func [Float] -> Int
// Dibuja la funcion f en el intervalo x
function y = dibujar(f, x)
  plot(x,f)
  a=gca();
  a.x_location = "origin";
  a.y_location = "origin";
  y = 0
endfunction

// CASOS DE PRUEBA:
// --> deff("y = h(x)", "y = 2*x - 2")
// --> dibujar(h, [-5:0.1:5])

// metodo_biseccion :: (Float -> Float) Float Float Float -> Float
// Dado una funcion y dos puntos (a y b / f(a) * f(b) < 0)
// calcula la raiz de f en el interbalo [a, b] con un error de e
function v = metodo_biseccion(f, a, b, e)
  if (f(a) * f(b)) >= 0 then
    v = %nan
  else
    c = (a + b) / 2
    cnt = 0
    while b - c > e then
      if (f(b) * f(c)) <= 0 then
        a = c
      else
        b = c
      end
      c = (a + b) / 2
      cnt = cnt + 1
    end

    disp(cnt)
    v = c
  end
end

// CASOS DE PRUEBA:
// --> deff("y = h(x)", "y = 2*x - 2")
// --> metodo_biseccion(h, 0, 4, 10^-8)
//    28.
//  ans  =
//    1.

// metodo_newton :: (Float -> Float) Float Float Int -> Float
// Dada una funcion f, un punto inicial x0, una tolerancia de error e y una
// cantidad maxima de iteraciones
// Calcula el valor v talque f(v) = 0
function v = metodo_newton(f, x0, e, iter)
  xn = x0 - (f(x0) / numderivative(f, x0))
  i = 2
  while (abs(xn - x0) > e) && (i < iter) then
    x0 = xn
    xn = x0 - (f(x0) / numderivative(f, x0))
    i = i + 1
  end

  disp(i)
  v = xn
endfunction

// CASOS DE PRUEBA:
// --> deff("y = h(x)", "y = 2*x - 2")
// --> metodo_newton(h, -3, 10^-8, 200)
//    3.
//  ans  =
//    1.

// ---------------------------------------------------------------------------

deff("y=f1(x)", "y=sin(x)/x")
// Si graficamos, podemos ver que la una raiz esta entre -4 y -2
// y la otra entre 2 y 4
// --> dibujar(f1, [0:0.1:5])
// Primero f(2)*f(4) < 0 => Podemos usar el metodo de la
// biseccion

// --> metodo_biseccion(f1, 2, 4, 10^-5)
//    17.
//  ans  =
//    3.1415939

deff("y=Df1(x)", "y=(x*cos(x) - sin(x))/x^2")
// --> dibujar(Df1, [0:0.1:5])
// Evidentemente la derivada es menor a un en este punto, por lo que podemos
// usar el metodo de newton
// --> metodo_newton(f1, 2, 10^-5, 200)
//   5.
// ans  =
//   3.1415927

// d) Podemos ver que el metodo de Newton converge a mayor velocidad ya que 
// este realiza menos iteraciones que el metedo de la biseccion
// Tambien sabemos que el metodo de newton tiene convergencia cuadratica,
// mientras el de la biseccion es lineal.
// El unico problema, es que el metodo de newton puede no converger ya que
// se necesita que la derivada sea continua en todo el intervalo a evaluar

// e) Si nosotros dibujamos la derivada de f1:
// --> dibujar(Df1, [-5:0.1:5])
// Podemos ver que esta no es continua en 0, por lo que no podemos calcular
// la raiz partiendo de este punto.
// En el caso de aproximar la derivada de f1 en el punto 0 (lo cual es 0),
// tampoco podemos usar este metodo ya que estariamos dividiendo por 0.
