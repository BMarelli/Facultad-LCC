module Practica6 where

import Seq
import Par
import ListSeq
data Paren = Open | Close
             deriving Show

{- Ejercicio 1 -}
-- promedios :: Seq s => s Int -> s Float
-- promedios xs = let (ys, y) = scanS (+) 0 xs
--                    zs = appendS (dropS ys 1) (singletonS y)
--                in tabulateS (\x -> (nthS zs x) / x) (lengthS zs)

-- -- TODO: Hacer bien
-- mayores :: Seq s => s Int -> Int
-- mayores xs = let (ys, y) = scanS maximo minBound xs
--                  zs = appendS (dropS ys 1) (singletonS y)
--              in (reduceS (+) 0 (tabulateS (\i -> if (nthS xs i) == (nthS zs i) then 1 else 0) (lengthS zs))) - 1
--     where
--       maximo a b = if a == b then minBound else max a b

{- Ejercicio 4 -}
matchParen :: Seq s => s Paren -> Bool
matchParen xs = let ys = mapS parenToInt xs
                    (zs, z) = scanS (+) 0 ys
                in (reduceS min 0 zs == 0) && (z == 0)
    where
      parenToInt Open = 1
      parenToInt Close = -1

{- Ejercicio 6 -}
tuplasMultiplos :: Seq s => s a -> s (a, s a)
tuplasMultiplos ys = tabulateS (\i -> (nthS ys i, dropS ys i)) ((lengthS ys) - 1)

multiplos :: Seq s => (Int, s Int) -> Int
multiplos (n, ys) = lengthS (filterS (\y -> (mod n y) == 0) ys)

cantMultiplos :: Seq s => s Int -> Int
cantMultiplos xs = reduceS (+) 0 (mapS multiplos (tuplasMultiplos xs))
