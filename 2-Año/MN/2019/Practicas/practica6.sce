// Ejercicio 4: círculos de Gershgorín (falta el 4c)

// Dibuja una circunferencia de radio r centrada en el punto (x,y).

function []=circ(x, y, r, autovalores)
    r0 = max(r)
    n = size(x,1)
    title("Círculos de Gerschgorín")
    for i = 1 : n
        plot2d(x(i),y,-1, "031", " ", [x(i)-2*r0, y-2*r0, x(i)+2*r0, y+2*r0]) // Recuadro
        xgrid(3) // El numero es para el color de la grilla (3 --> verde)
        xset("color", 2) //Color: 2 --> azul
        xarc(x(i)-r(i), y+r(i), 2*r(i), 2*r(i), 0, 360*64) // Circunferencia    
    end
    for i = 1 : size(autovalores, 1)
        re = real(autovalores(i))
        img = imag(autovalores(i))
        plot2d(re, img, -10)
    end
endfunction
 
// Función que toma una matriz y dibuja todos los circulos de Gerschgorín.

// Revisar que el recuadro de la grafica no quede chico para algun circulo

function []=gersch(A)
    n = size(A, 1)
    // Calculamos los radios Ri:
    r = zeros(n, 1)
    x = diag(A)
    for i = 1 : n
        for j = 1 : n
            if j <> i then
                r(i) = r(i) + abs(A(i, j))
            end
        end
        // Graficamos
    end
    autovalores = spec(A)
    circ(x, 0, r, autovalores)
endfunction

// Metodo de la Potencia
function x = metodo_potencia(A, z)
    n = size(A, 1)
    bool = %t
    for i = 1 : n
        for j = 1:n
            bool = bool & A(i, j) == A(j, i)
        end
    end

    if (bool) then
        z0 = z

        w1 = A * z0
        z1 = w1 / norm(w1, "inf")
        [wk, k] = max(abs(w1))
        l1 = w1(k) / z0(k)

        w2 = A * z1
        z2 = w2 / norm(w2, "inf")
        [wk, k] = max(abs(w2))
        l2 = w2(k) / z1(k)

        w3 = A * z2
        z3 = w3 / norm(w3, "inf")
        [wk, k] = max(abs(w3))
        l3 = w3(k) / z2(k)

        r = (l3-l2)/(l2-l1)

        while(r/(1-r) * (l3 - l2) > 1e-12)
            z2 = z3
            w3 = A*z2
            z3 = w3/norm(w3, "inf")

            l1 = l2
            l2 = l3
            [wk, k] = max(abs(w3))
            l3 = w3(k) / z2(k)
            r = (l3-l2)/(l2-l1)
        end
        x = l3
    else
        disp("La matriz no es simetrica.")
        x = %nan
    end
endfunction
