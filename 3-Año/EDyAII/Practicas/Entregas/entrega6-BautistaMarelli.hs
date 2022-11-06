-- Practica 6 - Entrega - Bautista Marelli - EDyAII

{- Ejercicio 4 -}
matchParen :: Seq s => s Paren -> Bool
matchParen xs = let ys = mapS parenToInt xs
                    (zs, z) = scanS (+) 0 ys
                in (reduceS min 0 zs == 0) && (z == 0)
    where
      parenToInt Open = 1
      parenToInt Close = -1

{- Ejercicio 6 -}
{- 
Tenia una pregunta y como no pude ir a la ultima consulta, la escribo aca:
No se porque me tiraba error cuando queria definir las dos funciones auxiliares adentro de un `where`.

De esta forma:

cantMultiplos :: Seq s => s Int -> Int
cantMultiplos xs = let ys = tuplasMultiplos xs
                       zs = mapS multiplos ys
                   in reduceS (+) 0 zs
    where
      tuplasMultiplos ys = tabulateS (\i -> (nthS ys i, dropS ys (i + 1))) ((lengthS ys) - 1)
      multiplos (n, ys) = lengthS (filterS (\y -> (mod n y) == 0) ys)
-}

{- Solucion al problema -}
{-
cantMultiplos :: Seq s => s Int -> Int
cantMultiplos xs = let ys = tuplasMultiplos xs
                       zs = mapS multiplos ys
                   in reduceS (+) 0 zs
      where
        tuplasMultiplos :: Seq s => s Int -> s (Int, s Int)
        tuplasMultiplos ys = tabulateS (\i -> (nthS ys i, dropS ys (i + 1))) ((lengthS ys) - 1)
        multiplos (n, ys) = lengthS (filterS (\y -> (mod n y) == 0) ys)
-}

-- Esta es la versión que anda:

tuplasMultiplos :: Seq s => s a -> s (a, s a)
tuplasMultiplos ys = tabulateS (\i -> (nthS ys i, dropS ys (i + 1))) ((lengthS ys) - 1)

multiplos :: Seq s => (Int, s Int) -> Int
multiplos (n, ys) = lengthS (filterS (\y -> (mod n y) == 0) ys)

cantMultiplos :: Seq s => s Int -> Int
cantMultiplos xs = let ys = tuplasMultiplos xs
                       zs = mapS multiplos ys
                   in reduceS (+) 0 zs
