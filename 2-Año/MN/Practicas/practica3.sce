// Practica 3
// Ejercicio 1
deff('y = G(x)', 'y = (cos(x) .* cosh(x)) + 1')

// Ejercicio 2: Metodo de la Biseccion
deff('y = Nat1(x)', 'y = sin(x) - (x^2)/2')
deff('y = Nat2(x)', 'y = exp(-x) - x^4')
deff('y = Nat3(x)', 'y = log10(x) - x + 1')
function y = metodo_biseccion(f, a, b, e)
    c = (a+b)/2
    if  (b - c <= e) then
        y = c
    else
          if (f(b) * f(c) < 0) then
             y = metodo_biseccion(f, c, b, e)
          else
              y = metodo_biseccion(f, a, c, e)
          end
    end
endfunction

// Ejercicio 3
deff('y = Nat4(x)', 'y = ((x^2) / 4) - sin(x)')
function y = metodo_secante(f, x0, x1, e)
    while (abs(f(x1) - f(x0)) > e)
        xn = x1 - (f(x1) * (x1- x0) / (f(x1) - f(x0)))
        x0 = x1
        x1 = xn
    end
    y = x1
endfunction

// Ejercicio 6: método del punto fijo.

deff('y = g(x)', 'y = x + (0.1) * ((x^2) - 5)')

// Ejercicio 8

deff('y = g1(x)', 'y = exp(x) / 3')
deff('y = g2(x)', 'y = (exp(x) - x) / 2')
deff('y = g3(x)', 'y = log(3 * x)')
deff('y = g4(x)', 'y = exp(x) - 2 * x')

// Metodo del Punto Fijo
function y = metodo_pun_fijo_(g, e, x, raiz)
    while(abs((raiz - x)/(raiz)) > e)
        x = g(x)   
    end
    y = x
endfunction

// Ejercicio 9: método de Newton
function y = h(x)
    y(1) = 1 + x(1)^2 - x(2)^ 2 + exp(x(1)) * cos(x(2))
    y(2) = (2 * x(1) * x(2)) + (exp(x(1)) * sin(x(2)))
endfunction

// metodo_de_newton: F x0 e -> y
// Recibe un sistema (puede ser simple), un valor inicial,
// y el error
// Devuelve el valor de x cuando los sistemas son 0
function y = metodo_de_newton(F, x0, e)
    while(norm(F(x0)) >= e)
        J = numderivative(F, x0)
        x0 = x0 - (inv(J) * F(x0))
    end
    y = x0
endfunction

// Ejercicio 10:

// Sistema de ecuaciones:

function y = g(x)
    y(1) = x(1)^2 + x(1)*(x(2)^3) - 9
    y(2) = 3*(x(1)^2)*x(2) - 4 - x(2)^3
endfunction

// Puntos a evaluar:

p1 = [1.2; 2.5] //Solo p1 se aproxima a uno de los 4
                // puntos de intersección.
p2 = [-2; 2.5]
p3 = [-1.2; -2.5]
p4 = [2; -2.5]

// Ejercicio 11
function y = f(x)
    y = 2 * x(1) + 3 * x(2)^2 + exp((2 * x(1)^2) + x(2)^2)
endfunction

function y = dF(x)
    y(1) = 2 + exp(2*x(1)^2 + x(2)^2) * 4*x(1)
    y(2) = 6 * x(2) + exp(2*x(1)^2 + x(2)^2) * 2*x(2)
endfunction

deff('z = f1(x, y)', 'z = 2*x + 3*y^2 + exp(2*x^2 + y^2)')
deff('z = f2(x, y)', 'z = 2*cos(x) + y^3')

// Ejercicio 11: Minimos locales
// tipo 0: silla
// tipo 1: minimo
// tipo 2: maximo
function [y, tipo] = minimos_locales(Df, x0, e)
    // deff("y = Df(x)", "y = numderivative(f, x);")
    y = metodo_de_newton_multiv(Df, x0, e)
    H = numderivative(Df, x0)
    n = size(y, 1)
    determinantes = zeros(n, 0)
    for (i = 1 : n)
        determinantes(i) = det(H(1:i, 1:i)) > 0
    end

    if (and(determinantes))
        tipo = 1
    else
        i = 1
        while (i <= n) then
            determinantes(i) = ~ determinantes(i)
            i = i + 2
        end
        if (and(determinantes))
            tipo = 2
        else
            tipo = 0
        end
    end
endfunction

// Ejercicio 12:
function y = f12(x)
    y(1) = x(1) * exp(x(2)) + x(3) - 10
    y(2) = x(1) * exp(2 * x(2)) + 2 * x(3) - 12
    y(3) = x(1) * exp(3 * x(2)) + 3 * x(3) - 15
endfunction