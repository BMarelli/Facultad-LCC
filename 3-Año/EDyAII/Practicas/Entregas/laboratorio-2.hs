module Lab02 where

{-
   Laboratorio 2
   EDyAII 2020
-}

import Data.List

{-
1) Inferir, de ser posible, los tipos de las siguientes funciones:
(puede suponer que sqrt :: Float → Float)
-}

-- a)
modulus :: Floating a => [a] -> a
modulus = sqrt . sum . map (^2)

-- b)
vmod :: Floating a => [[a]] -> [a]
vmod [] = []
vmod (v : vs) = modulus v : vmod vs


-- 2) Dado el siguiente tipo para representar números binarios:
type NumBin = [Bool]

{- donde el valor False representa el número 0 y True el 1. Definir las siguientes operaciones tomando como convención una representación Little-Endian (i.e. el primer elemento de las lista de dı́gitos es el dı́gito menos significativo del número representado).-}

--a) suma binaria
incBin :: NumBin -> NumBin
incBin [] = [True]
incBin (x:xs) = if x then False : incBin xs else True : xs

sumaBin :: NumBin -> NumBin -> NumBin
sumaBin xs [] = xs
sumaBin [] ys = ys
sumaBin (x:xs) (y:ys) = if x && y then False : incBin (sumaBin xs ys)
                        else (x || y) : sumaBin xs ys

--b) producto binario
prodBin :: NumBin -> NumBin -> NumBin
prodBin _ [] = [False]
prodBin [] _ = [False]
prodBin xs [y] = if y then xs else [False]
prodBin xs (y:ys) = if y then sumaBin xs (False : prodBin xs ys)
                    else False : prodBin xs ys
-- c) cociente y resto de la división por dos

cociente2 :: NumBin -> NumBin
cociente2 (x:xs) = xs

modBin2 :: NumBin -> NumBin
modBin2 (x:xs) = [x]


-- 3) Dado el tipo de datos
data CList a = EmptyCL | CUnit a | Consnoc a (CList a) a
               deriving Show

{-a) Implementar las operaciones de este tipo algebraico teniendo en cuenta que:

* Las funciones de acceso son headCL, tailCL, isEmptyCL, isCUnit.
* headCL y tailCL no están definidos para una lista vacı́a.
* headCL toma una CList y devuelve el primer elemento de la misma (el de más a la izquierda).
* tailCL toma una CList y devuelve la misma sin el primer elemento.
* isEmptyCL aplicado a una CList devuelve True si la CList es vacı́a (EmptyCL) o False en caso contrario.
* isCUnit aplicado a una CList devuelve True sii la CList tiene un solo elemento (CUnit a) o False en caso contrario.-}

headCL :: CList a -> a
headCL (CUnit x) = x
headCL (Consnoc x xs y) = x

tailCL :: CList a -> CList a
tailCL (CUnit x) = EmptyCL
tailCL (Consnoc x xs y) = case xs of 
                                EmptyCL -> CUnit y
                                CUnit z -> Consnoc z EmptyCL y
                                otherwise -> Consnoc (headCL xs) (tailCL xs) y
 
isEmptyCL :: CList a -> Bool
isEmptyCL EmptyCL = True
isEmptyCL _ = False

isCUnit :: CList a -> Bool
isCUnit (CUnit x) = True
isCUnit _ = False

-- b) Definir una función reverseCL que toma una CList y devuelve su inversa.
reverseCL :: CList a -> CList a
reverseCL EmptyCL = EmptyCL
reverseCL (CUnit x) = CUnit x 
reverseCL (Consnoc x xs y) = case xs of
                              EmptyCL -> Consnoc y EmptyCL x
                              CUnit z -> Consnoc y (CUnit z) x
                              otherwise -> Consnoc y (reverseCL xs) x

-- c) Definir una función inits que toma una CList y devuelve una CList con todos los posibles inicios de la CList.

-- Dada una CList xs y un elemento x, agrega el elementox a al final de la CList xs
snocCL :: CList a -> a -> CList a
snocCL EmptyCL x = CUnit x
snocCL xs x = case xs of
                  CUnit y -> Consnoc y EmptyCL x
                  Consnoc z1 zs z2 -> Consnoc z1 (snocCL zs z2) x

-- Dada una CList xs, elimina el ultimo elemento de la misma
eliUltCL :: CList a -> CList a
eliUltCL (CUnit x) = EmptyCL
eliUltCL (Consnoc x ys z) = case ys of
                                 EmptyCL -> CUnit x
                                 CUnit y -> Consnoc x EmptyCL y
                                 otherwise -> Consnoc x (eliUltCL ys) (ult ys)
   where ult (CUnit x_)          = x_
         ult (Consnoc x_ xs_ y)  = y 

inits :: CList a -> CList (CList a)
inits EmptyCL = CUnit EmptyCL
inits (CUnit x) = Consnoc EmptyCL EmptyCL (CUnit x) -- [[], [x]]
inits x = snocCL (inits (eliUltCL x)) x

-- d) Definir una función lasts que toma una CList y devuelve una CList con todas las posibles terminaciones de la CList.
-- Dada una CList xs y un elemento x, agrega el elementox a al inicio de la CList xs
consCL :: CList a -> a -> CList a
consCL EmptyCL x = CUnit x
consCL xs x = case xs of
                  CUnit y -> Consnoc x EmptyCL y
                  Consnoc z1 zs z2 -> Consnoc x (consCL zs z1) z2

-- Dada una CList xs, elimina el primer elemento de la misma
eliPrimCL :: CList a -> CList a
eliPrimCL (CUnit x) = EmptyCL
eliPrimCL (Consnoc x ys z) = case ys of
                                 EmptyCL -> CUnit z
                                 CUnit y -> Consnoc y EmptyCL z
                                 otherwise -> Consnoc (prim ys) (eliPrimCL ys) z
   where prim (CUnit x_)          = x_
         prim (Consnoc x_ xs_ y)  = x_

lasts :: CList a -> CList (CList a)
lasts EmptyCL = CUnit EmptyCL
lasts (CUnit x) = Consnoc (CUnit x) EmptyCL EmptyCL -- [[], [x]]
lasts x = consCL (lasts (eliPrimCL x)) x


-- e) Definir una función concatCL que toma una CList de CList y devuelve la CList con todas ellas concatenadas

(*+*) :: CList a -> CList a -> CList a
(*+*) x EmptyCL = x
(*+*) EmptyCL x = x
(*+*) (CUnit x) ys = case ys of
                              CUnit y -> Consnoc x EmptyCL y
                              Consnoc y zs z -> Consnoc x ((CUnit y) *+* zs) z
(*+*) (Consnoc x1 xs x2) ys = case ys of
                                    CUnit y -> Consnoc x1 (xs *+* (CUnit x2)) y
                                    Consnoc z1 zs z2 -> Consnoc x1 (( xs *+* (CUnit x2)) *+* ((CUnit z1) *+* zs)) z2

concatCL :: CList(CList a) -> CList a
concatCL EmptyCL = EmptyCL
concatCL (CUnit x) = x
concatCL (Consnoc xs ys zs) = (xs *+* (concatCL ys)) *+* zs

-- 4) Dada las siguientes representaciones de árboles generales y de árboles binarios

data GenTree a = EmptyG | NodeG a [GenTree a]

data BinTree a = EmptyB | NodeB (BinTree a) a (BinTree a)

{-defina una función g2bt que dado un árbol nos devuelva un árbol binario de la siguiente manera:
la función g2bt reemplaza cada nodo n del árbol general (NodeG) por un nodo n' del árbol binario (NodeB ), donde
el hijo izquierdo de n' representa el hijo más izquierdo de n, y el hijo derecho de n' representa al hermano derecho
de n, si existiese (observar que de esta forma, el hijo derecho de la raı́z es siempre vacı́o).-}

g2btaux :: [GenTree a] -> BinTree a
g2btaux xs = case xs of
                  [] -> EmptyB
                  ((NodeG y ys):zs) -> NodeB (g2btaux ys) y (g2btaux zs)

g2bt :: GenTree a -> BinTree a
g2bt EmptyG = EmptyB
g2bt (NodeG x xs) = NodeB (g2btaux xs) x EmptyB

-- g2bt EmptyG = EmptyB
-- g2bt (NodeG x xs) = case xs of
--                         [] -> NodeB EmptyB x EmptyB
--                         (NodeG y ys):zs -> NodeB (g2bt (NodeG y ys)) x 

-- 5) Definir las siguientes funciones sobre árboles binarios de búsqueda (bst):

data BST a = Hoja | Nodo (BST a) a (BST a)
--a) maximum, que calcula el maximo valor en un bst.

maximumBST :: Ord a => BST a -> a
maximumBST (Nodo _ x y) = case y of
                           Hoja -> x
                           Nodo _ z zs -> maximumBST y

--b) checkBST, que chequea si un árbol binario es un bst.

minimumBST :: Ord a => BST a -> a
minimumBST (Nodo x y _) = case x of
                              Hoja -> y
                              Nodo zs z _ -> minimumBST x

checkBST :: Ord a => BST a -> Bool
checkBST Hoja = True
checkBST (Nodo Hoja _ Hoja) = True
checkBST (Nodo xs x Hoja) = (maximumBST xs) < x && (checkBST xs)
checkBST (Nodo Hoja x xs) = x < (minimumBST xs) && (checkBST xs)
checkBST (Nodo xs y zs) = (maximumBST xs) < y && y < (minimumBST zs) && (checkBST xs) && (checkBST zs)
