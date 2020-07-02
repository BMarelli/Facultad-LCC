// Practica 4

// Ejercicio 1:

function sol = resuelve_triang_sup(A, b)
    n = size(A, 1)
    sol(n) = b(n)/ A(n,n)
    for i = n - 1 : -1 : 1
        sol(i) = (b(i) - A(i, i+1 : n) * sol(i+1 : n)) / A(i, i)
    end
endfunction

function x = resuelve_triang_inf(A, b)
    n = size(A, 1)
    x(1) = b(1)/A(1, 1)
    for i = 2: n
        x(i) = (b(i) - A(i, 1 : i - 1) * x(1 : i - 1))/A(i, i)
    end
endfunction

function [s1, s2] = gauss(A, b)
    n = size(A, 1)
    for i = 1 : (n-1)
        for j = i + 1 : n
            mjk = A(j, i)/A(i,i)
            A(j,i:n) = A(j,i:n) - mjk * A(i, i:n)
            b(j) = b(j) - mjk * b(i)
        end
    end
    s1 = A
    s2 = b
endfunction

function x = resolver_gauss(A, b)
    [A, b] = gauss(A, b)
    x = resuelve_triang_sup(A, b)
endfunction

// Ejercicio 3
// resolver_mult_sist_gauss: Matriz(n, n) Matriz(n,m) -> Matriz(n,n)
// Resuelve los sistemas: A*x(1:n, i) = b(1:n, i)
// Recibe una matriz A de coeficientes de los sistemas, y b 
// Devuelve x, donde la col_i es la solucion del sistema_i
function x = resolver_mult_sist_gauss(A, b)
    n = size(A, 1)
    m = size(b, 2)
    for i = 1 : m
        x(1:n, i) = resolver_gauss(A, b(1:n, i))
    end
endfunction

function A_i = calcular_inversa(A)
    n = size(A, 1)
    A_i = resolver_mult_sist_gauss(A, eye(n, n))
endfunction

// Esta función obtiene la solución del sistema de ecuaciones lineales A*x=b, 
// dada la matriz de coeficientes A y el vector b.
// La función implementa el método de Eliminación Gaussiana con pivoteo parcial.
function [x,a, P] = gaussElimPP(A,b)
    [nA,mA] = size(A) 
    [nb,mb] = size(b)
    
    if nA<>mA then
        error('gausselim - La matriz A debe ser cuadrada');
        abort;
    elseif mA<>nb then
        error('gausselim - dimensiones incompatibles entre A y b');
        abort;
    end;
    
    a = [A b]; // Matriz aumentada
    n = nA;    // Tamaño de la matriz
    P = eye(n, n)
    
    // Eliminación progresiva con pivoteo parcial
        temp = P(k, :)
        P(k, :) = P(kpivot, :)
        P(kpivot, :) = temp

        for i=k+1:n
            for j=k+1:n+1
                a(i,j) = a(i,j) - a(k,j)*a(i,k)/a(k,k);
            end;
            for j=1:k        // no hace falta para calcular la solución x
                a(i,j) = 0;  // no hace falta para calcular la solución x
            end              // no hace falta para calcular la solución x
        end;
    end;
    
    // Sustitución regresiva
    x(n) = a(n,n+1)/a(n,n);
    for i = n-1:-1:1
        sumk = 0
        for k=i+1:n
            sumk = sumk + a(i,k)*x(k);
        end;
        x(i) = (a(i,n+1)-sumk)/a(i,i);
    end;
endfunction

// Ejercicio 6: no puedo mostrar la cantidad de operaciones en pantalla ggg.
function x = eliminacion_tridiagonal(A, b)
    n = size(A, 1)
    for i = 1 : n-1
        m = A(i + 1, i)/A(i,i)
        // Sólo necesitamos hacer ceros debajo de Aii en
        // la fila i + 1 (por ser tridiagonal), y tampoco
        // es necesario restar la fila i con la fila i+1
        // entera (por el mismo motivo).
        A(i + 1, i) = A(i + 1, i) - m*A(i,i)
        A(i+1, i+1) = A(i+1, i+1) - m*A(i, i + 1)  
        b(i+1) = b(i+1) - m*b(i)
    end
    x = resuelve_triang_sup(A, b)
endfunction

// Ejercicio 7: factorización LU. (no entiendo pq anda gg)

function [P, L, U] = fact_lu(A)
// Dada una matriz A obtiene su factorización LU
// con pivoteo parcial.
    U = A
    n = size(A, 1)
    L = eye(n, n)
    P = eye(n, n)
    for k = 1 : n - 1
        maxUik = abs(U(k, k))
        for i = k + 1 : n
            // i que maximiza Uik
            if abs(U(i, k)) > maxUik then
                maxUik = abs(U(i, k))
                // Intercambio de filas.
                temp = U(k, k:n)
                U(k, k:n) = U(i, k:n)
                U(i, k:n) = temp
                
                temp = L(k, 1:k-1)
                L(k, 1:k-1) = L(i, 1:k-1)
                L(i, 1:k-1) = temp
                
                temp = P(k, :)
                P(k, :) = P(i, :)
                P(i, :) = temp
            end
        end
        for j = k + 1 : n
            L(j, k) = U(j, k) / U(k, k)
            U(j, k:n) = U(j, k:n) - L(j, k)*U(k, k:n)
        end
    end
endfunction

// Método de Doolittle

function [L, U] = doolittle(A)
L = zeros((size(A)))
U = zeros((size(A)))
n = size(A, 1)
// Recorremos en orden las columnas.
for j = 1 : n
    for i = 1 : n
        // Estamos por arriba de la diagonal.
        if i <= j then
            U(i, j) = A(i, j)
            for k = 1 : i - 1
                U(i, j) = U(i, j) - L(i, k) * U(k, j)
            end
        end
        if j <= i then
            L(i, j) = A(i, j)
            for k = 1 : j-1
                L(i, j) = L(i, j) - L(i, k) * U(k, j)
            end
            L(i, j) = L(i, j) / U(j, j)
        end
    end
end
endfunction

function x = resolver_doolittle(A, b)
    [L, U] = doolittle(A)
    Y = resuelve_triang_inf(L, b)
    x = resuelve_triang_sup(U, Y)
endfunction

// Cholesky
function [U,ind] = cholesky(A)
// Factorización de Cholesky.
// Trabaja únicamente con la parte triangular superior.
//
// ind = 1  si se obtuvo la factorización de Cholesky.
//     = 0  si A no es definida positiva
//
//******************
eps = 1.0e-8
//******************

n = size(A,1)
U = zeros(n,n)

for k = 1:n
    t = A(k,k) - U(1:k-1,k)'*U(1:k-1,k)
    if t <= eps then
        printf('Matriz no definida positiva.\n')
        ind = 0
        return
    end
    U(k,k) = sqrt(t)
    for j = k+1:n
        U(k,j) = (A(k,j) - U(1:k-1,k)' * U(1:k-1,j) )/U(k,k)
    end
end
ind = 1
endfunction