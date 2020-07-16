module Practica6 where

import Seq
import Par
import ListSeq
data Paren = Open | Close
             deriving Show

{- Ejercicio 1 -}
promedios :: Seq s => s Int -> s Int
promedios xs = let (ys, y) = scanS (+) 0 xs
                   zs = appendS (dropS ys 1) (singletonS y)
               in tabulateS (\i -> div (nthS xs i) i) (lengthS zs)


{- Ejercicio 2 -}
fibSeq :: Seq s => Nat -> s Nat


{- Ejercicio 4 -}
matchParen :: Seq s => s Paren -> Bool
matchParen xs = let ys = mapS parenToInt xs
                    (zs, z) = scanS (+) 0 ys
                in (reduceS min 0 zs == 0) && (z == 0)
    where
      parenToInt Open = 1
      parenToInt Close = -1

{- Ejercicio 6 -}
cantMultiplos :: Seq s => s Int -> Int
cantMultiplos xs = let ys = tuplasMultiplos xs
                       zs = mapS multiplos ys
                   in reduceS (+) 0 zs
    where
      tuplasMultiplos :: Seq s => s Int -> s (Int, s Int)
      tuplasMultiplos ys = tabulateS (\i -> (nthS ys i, dropS ys (i + 1))) ((lengthS ys) - 1)
      multiplos (n, ys) = lengthS (filterS (\y -> (mod n y) == 0) ys)
