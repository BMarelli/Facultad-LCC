// TODO: implementar funcion inversa matriz

function bool = converge(A)
    n(1) = norm(A, 1)
    n(2) = norm(A, 'inf')
    n(3) = norm(A, 'fro')
    n(4) = norm(A)
    bool = min(n) >= 1 & max(abs(spec(Norma))) >= 1
endfunction

// Método de Jacobi utilizando la fórmula matricial.

// x0 --> Aproximación inicial.
// e --> Tolerancia del error.

function x = metodo_jacobi(A, b, x0, e)
    nA = size(A, 1)
    // Primero pivoteamos la matriz A y el vector b por si hay
    // elementos nulos en la diagonal principal de A.
    for k=1:nA-1
        [v,i]=max(abs(A(k:nA,k)))
        kpivot = k-1+i
        temp = A(kpivot,:); A(kpivot,:) = A(k,:); A(k,:) = temp
        temp = b(kpivot,:); b(kpivot,:) = b(k,:); b(k,:) = temp
        temp = x0(kpivot,:); x0(kpivot,:) = x0(k,:); x0(k,:) = temp
    end

    N = diag(diag(A))
    NI = inv(N)
    I = eye(nA, nA)
    // Calculamos los 4 tipos de normas para verificar la convergencia.
    Norma = I-NI*A
    
    // Si el método no converge mostramos el error por pantalla.
    if converge(Norma) then
        x = 0 // Lo tuve q poner pq sino me daba error ggg.
        disp("El método no converge para el sistema dado.")
    // El método converge, comenzamos a aproximar la solución.
    else
        xAct = x0 
        while norm(A*xAct - b) >= e
            xSig = NI * ((N - A) * xAct + b)
            xAct = xSig
        end
        x = xSig
    end
endfunction

// Método de Jacobi (usando la otra fórmula)

function x = metodo_jacobi2(A, b, x0, e)
    nA = size(A, 1)
    // Primero pivoteamos la matriz A y el vector b por si hay
    // elementos nulos en la diagonal principal de A.
    for k=1:nA-1
        [v,i]=max(abs(A(k:nA,k)))
        kpivot = k-1+i
        temp = A(kpivot,:); A(kpivot,:) = A(k,:); A(k,:) = temp
        temp = b(kpivot,:); b(kpivot,:) = b(k,:); b(k,:) = temp
        temp = x0(kpivot,:); x0(kpivot,:) = x0(k,:); x0(k,:) = temp
    end

    N = diag(diag(A))
    NI = inv(N)
    I = eye(nA, nA)
    // Calculamos los 4 tipos de normas para verificar la convergencia.
    Norma = I-NI*A
    // Si el método no converge mostramos el error por pantalla.
    if converge(Norma) then
        x = 0 // Lo tuve q poner pq sino me daba error ggg.
        disp("El método no converge para el sistema dado.")
    // El método converge, comenzamos a aproximar la solución.
    else
        xAct = x0 
        while norm(A*xAct - b) >= e
            for i = 1 : nA
                suma = 0
                for j = 1 : nA
                    if j <> i then
                        suma = suma + (A(i, j) * xAct(j)) / A(i, i)
                    end
                end
                xSig(i) = b(i) / A(i, i) - suma
            end
            xAct = xSig
        end
        x = xSig
    end
endfunction

// Determina si una matriz es diagonal dominante.

function n = es_diag_dominante(A)
    n = 1
    nA = size(A, 1)
    for i = 1 : nA
        suma = 0
        for j = 1 : nA
            if (i <> j) then
                suma = suma + abs(A(i, j))
            end
        end
        if suma >= A(i, i) then
            n = 0
        end
    end
endfunction


// Método de Gauss-Seidel. 

// NOTE: Probar q ande jejex

function x = metodo_gauss_seidel(A, b, x0, e)
    
    nA = size(A, 1)
    I = zeros(nA, nA)
    // Primero pivoteamos la matriz A y el vector b por si hay
    // elementos nulos en la diagonal principal de A.
    for k=1:nA-1
        [v,i]=max(abs(A(k:nA,k)))
        kpivot = k-1+i
        temp = A(kpivot,:); A(kpivot,:) = A(k,:); A(k,:) = temp
        temp = b(kpivot,:); b(kpivot,:) = b(k,:); b(k,:) = temp
        temp = x0(kpivot,:); x0(kpivot,:) = x0(k,:); x0(k,:) = temp
    end
    
    N = zeros(nA, nA)
    // N es triangular inferior.
    for i = 1 : nA
        for j = 1 :nA
            if j <= i then
                N(i, j) = A(i, j)
            end
        end
    end
    NI = inv(N)
    Norma = I-NI*A

    if es_diag_dominante(A) == 0 & max(abs(spec(Norma))) >= 1 then
        x = %nan
        disp("El metodo no converge")
    else

        xAct = x0 
        while norm(A*xAct - b) >= e
            suma = 0
            // Aplicamos la fórmula para calcular la siguiente iteración.
            for i = 1 : nA
                suma1 = 0
                suma2 = 0
                // Primer sumatoria.
                for j = 1 : i - 1
                    suma1 = suma1 + A(i, j) * xSig(j)
                end
                // Segunda sumatoria.
                for j = i + 1 : nA
                    suma2 = suma2 + A(i, j) * xAct(j)
                end 

                xSig(i) = (b(i) - suma1 - suma2) / A(i, i)
            end
            xAct = xSig
        end
        x = xSig
    end
endfunction


// Ejercicio 3:

// La matriz debe tener la siguiente forma:

// (Caso 3x3):

// 0.5      0.      0.   
// 0.25     0.5     0.   
// 0.125    0.25    0.5

// Es decir, la diagonal principal esta formada por 1/2, la diagonal
// de abajo esta formada por 1/(2^2), la siguiente por 1/(2^3), y asi
// sucesivamente...
// Entonces, dado un n > 0 la función calcula la matriz correspondiente al 
// tamaño indicado. Dicha matriz es de la forma especificada anteriormente.

function m = matriz_tridiagonal(n)
    m = zeros(n, n)
    for i = 1 : n
        x(i) = 2^(-i)
    end
    c = 0
    for col = 1 : n // Cols
        for fil = 1 : n
            if fil > c then
                m(fil, col) = x(fil - c)
            end
        end
        c = c + 1
    end 
endfunction

// Ejercicio 4: terminar alta paja

// function resolver_sist(n)
//     A = 8 * eye(n, n) + 2*diag(ones(n-1, 1), 1) + 2*diag(ones(n-1, 1), -1) 
//         + diag(ones(n-3, 1), 3) + diag(ones(n-3, 1), 3)
//     b = ones(n, 1)
// -------------------------------------------

// Método de Sobrerrelajación (SOR)
// Si nos pasan el w comentamos nuestro w
// TODO: Convergencia
function x = metodo_sor(A, b, x0, e)
    n = size(A, 1)
    D = diag(diag(A))
    T = eye(n, n) - (inv(D) * A)
    radioSpec = max(abs(spec(T))) 
    w = 2/(1 + sqrt(1 - (radioSpec^2)))
    
    xAct = x0
    xSig = zeros(n, 1)

    if (radioSpec < 1)
        while(norm(A*xAct - b) >= e)
            sum1 = 0
            for j = 2:n
                sum1 = sum1 + A(1, j) * xAct(j)
            end
            xSig(1) = w/(A(1, 1)) * (b(1) - sum1) + (1 - w) * xAct(1)
        
            
            for i = 2 : n
                suma1 = 0
                suma2 = 0
                
                for j = 1 : i - 1
                    suma1 = suma1 + A(i, j)*xSig(j)
                end
                
                for k = i + 1 : n
                    suma2 = suma2 + A(i, k)*xAct(k)
                end
                
                xSig(i) = (w/A(i,i)) * (b(i) - suma1 - suma2) + (1 - w) * xAct(i)
                
                xAct = xSig
            end
        end
        x = xAct
    else
        disp("El metodo no converge")
        x = %nan
    end
endfunction
