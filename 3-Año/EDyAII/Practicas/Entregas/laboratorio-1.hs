module Lab01 where

import Data.List

{-
1) Corregir los siguientes programas de modo que sean aceptados por GHCi.
-}

-- a)
not_ b = case b of
    True -> False
	False -> True

-- b)
in_ [x]         =  []
in_ (x:xs)      =  x : in_ xs
in_ []          =  error "empty list"

-- c)
length_ []        =  0
length_ (_:l)     =  1 + length_ l

-- d)
list123 = 1:2:3:[]

-- e)
[]     ++! ys = ys
(x:xs) ++! ys = x : xs ++! ys

-- f)
addToTail x xs = map (+x) (tail xs)

-- g)
listmin xs = head (sort xs)

-- h) (*)
smap f [] = []
smap f [x] = [f x]
smap f (x:xs) = f x : (smap f xs)

-- 2. Definir las siguientes funciones y determinar su tipo:

-- a) five, que dado cualquier valor, devuelve 5

five :: a -> Num
five _ = 5

-- b) apply, que toma una función y un valor, y devuelve el resultado de
-- aplicar la función al valor dado

apply :: (a -> a) -> a -> a
apply f x = f x

-- c) ident, la función identidad
ident :: a -> a
ident x = x

-- d) first, que toma un par ordenado, y devuelve su primera componente
first :: (a, b) -> a
first (x,_) = x

-- e) derive, que aproxima la derivada de una función dada en un punto dado
derive :: Float a => (a -> a) -> a -> a -> a
derive f x h = (f (x + h) - f x) / h

-- f) sign, la función signo
sign :: Float -> Float
sign x | x == 0 = 0
       | x > 0 = 1
       | otherwise = -1

-- g) vabs, la función valor absoluto (usando sign y sin usarla)
vabs1 :: Float -> Float
vabs1 x = (sign x) * x

vabs2 :: Float -> Float
vabs2 x | x >= 0 = x
        | otherwise = -x

-- h) pot, que toma un entero y un número, y devuelve el resultado de
-- elevar el segundo a la potencia dada por el primero
pot :: Int -> Float -> Float
pot x y = y ^ x

-- i) xor, el operador de disyunción exclusiva
xor :: Bool -> Bool -> Bool
xor_ p q = (p || q) && not (p && q)

-- j) max3, que toma tres números enteros y devuelve el máximo entre llos
max3 :: Int -> Int -> Int -> Int
max3 x y z = max x (max y z)

-- k) swap, que toma un par y devuelve el par con sus componentes invertidas
swap :: (a,b) -> (b,a)
swap (x,y) = (y,x)

{- 
3) Definir una función que determine si un año es bisiesto o no, de
acuerdo a la siguiente definición:

año bisiesto 1. m. El que tiene un día más que el año común, añadido al mes de febrero. Se repite
cada cuatro años, a excepción del último de cada siglo cuyo número de centenas no sea múltiplo
de cuatro. (Diccionario de la Real Academia Espaola, 22ª ed.)

¿Cuál es el tipo de la función definida?
-}
esBisiesto :: Int -> Bool
esBisiesto x | ((mod x 4) == 0 && (mod x 100) /= 0) = True
             | (mod x 400) == 0 = True
             | otherwise False

{-
4)

Defina un operador infijo *$ que implemente la multiplicación de un
vector por un escalar. Representaremos a los vectores mediante listas
de Haskell. Así, dada una lista ns y un número n, el valor ns *$ n
debe ser igual a la lista ns con todos sus elementos multiplicados por
n. Por ejemplo,

[ 2, 3 ] *$ 5 == [ 10 , 15 ].

El operador *$ debe definirse de manera que la siguiente
expresión sea válida:

-}
    (*$) :: [Int] -> Int -> [Int]
    xs *$ y = [z * y | z <- xs]

    v = [1, 2, 3] *$ 2 *$ 4



-- 5) Definir las siguientes funciones usando listas por comprensión:

-- a) 'divisors', que dado un entero positivo 'x' devuelve la
-- lista de los divisores de 'x' (o la lista vacía si el entero no es positivo)
divisor :: Num a => a -> [a]
divisor x | x < 0 = []
          | otherwise = [y | y <- [1..x], (mod x y) == 0]

-- b) 'matches', que dados un entero 'x' y una lista de enteros descarta
-- de la lista los elementos distintos a 'x'
matches :: Eq a => a -> [a] -> [a]
matches x xs = [y | y <- xs, x == y]

-- c) 'cuadrupla', que dado un entero 'n', devuelve todas las cuadruplas
-- '(a,b,c,d)' que satisfacen a^2 + b^2 = c^2 + d^2,
-- donde 0 <= a, b, c, d <= 'n'
cuadruplas :: Int -> [(Int,Int,Int,Int)] cuadruplas n = [(a,b,c,d) | a <- [1..n],b <- [1..n],c <- [1..n],d <- [1..n], a^2 + b^2 == c^2 + d^2]

-- (d) 'unique', que dada una lista 'xs' de enteros, devuelve la lista
-- 'xs' sin elementos repetidos

-- _in :: Eq a => a -> [a] -> Bool
-- _in _ [] = False
-- _in x xs = or [x == y | y <- xs]

-- unique :: Num a => [a] -> [a]
-- unique [] = []
-- unique x:xs = if (_in_ x xs) then unique xs
--               else x:unique xs

unique :: [Int] -> [Int]
unique xs = [x | (x,i) <- zip xs [0..], not (elem x (take i xs))]

{- 
6) El producto escalar de dos listas de enteros de igual longitud
es la suma de los productos de los elementos sucesivos (misma
posición) de ambas listas.  Definir una función 'scalarProduct' que
devuelva el producto escalar de dos listas.

Sugerencia: Usar las funciones 'zip' y 'sum'. -}
scalarProduct :: Num a => [a] -> [a] -> a
scalarProduct _ [] = 0
scalarProduct [] _ = 0
scalarProduct xs ys = sum (map (\(x,y) -> x * y) (zip xs ys))


-- 7) Definir mediante recursión explícita
-- las siguientes funciones y escribir su tipo más general:

-- a) 'suma', que suma todos los elementos de una lista de números
suma :: [a] -> a
suma [] = 0
suma (x:xs) = x + suma xs

-- b) 'alguno', que devuelve True si algún elemento de una
-- lista de valores booleanos es True, y False en caso
-- contrario
alguno :: [Bool] -> Bool
alguno [] = False
alguno (x:xs) = x || alguno xs

-- c) 'todos', que devuelve True si todos los elementos de
-- una lista de valores booleanos son True, y False en caso
-- contrario
todos :: [Bool] -> Bool
todos [] = False
todos (x:xs) = x && xs

-- d) 'codes', que dada una lista de caracteres, devuelve la
-- lista de sus ordinales
code :: [Char] -> [Int]
code [] = []
code (x:xs) = (code xs) ++ (length_ xs)

-- e) 'restos', que calcula la lista de los restos de la
-- división de los elementos de una lista de números dada por otro
-- número dado
restos :: [Int] -> Int -> [Int]
restos [] _ = []
restos (x:xs) y = (mod x y) : restos xs y

-- f) 'cuadrados', que dada una lista de números, devuelva la
-- lista de sus cuadrados
cuadrados :: [Float] -> [Float]
cuadrados [] = []
cuadrados (x:xs) = (x^2) : cuadrados xs

-- g) 'longitudes', que dada una lista de listas, devuelve la
-- lista de sus longitudes
longitudes :: [[a]] -> [Int]
longitudes [] = []
longitudes (x:xs) = (length_ x) : longitudes xs

-- h) 'orden', que dada una lista de pares de números, devuelve
-- la lista de aquellos pares en los que la primera componente es
-- menor que el triple de la segunda
orden :: Int a => [(a,a)] -> [(a,a)]
orden [] = []
orden ((x,y):xs) | x < 3*y = (x,y) : orden xs
                 | otherwise = orden xs

-- i) 'pares', que dada una lista de enteros, devuelve la lista
-- de los elementos pares

-- j) 'letras', que dada una lista de caracteres, devuelve la
-- lista de aquellos que son letras (minúsculas o mayúsculas)

-- k) 'masDe', que dada una lista de listas 'xss' y un
-- número 'n', devuelve la lista de aquellas listas de 'xss'
-- con longitud mayor que 'n'
masDe :: [[a]] -> Int -> [[a]]
masDe [] _ = []
masDe (x:xs) n | (length x > n) = x : masDe xs n
               | otherwise = masDe xs n
