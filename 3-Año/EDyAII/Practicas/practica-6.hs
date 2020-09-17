module Practica6 where

import Seq
import Par
import qualified Arr as A
import ListSeq
import ArrSeq
data Paren = Open | Close
             deriving Show

{- Ejercicio 1 -}
promedios :: Seq s => s Int -> s Float
promedios xs = let (ys, y) = scanS (+) 0 xs
                   zs = appendS (dropS ys 1) (singletonS y)
               in tabulateS (\i -> (fromIntegral (nthS zs i)) / (fromIntegral (i + 1))) (lengthS zs)

mayores :: Seq s => s Int -> Int
mayores xs = let 
              (ys, _) = scanS max minBound xs
              zs = zipS xs ys
             in (lengthS (filterS (\(x, y) -> x > y) zs)) - 1

{- Ejercicio 2 -}


{- Ejercicio 3 -}
aguaHist :: Seq s => s Int -> Int
aguaHist xs = let
                ys = tabulateS f' x
                (zs, z) = scanS g (0,0,0) ys
                ws = appendS (dropS zs 1) (singletonS z)
              in mapreduceS (\(x,y,z) -> (max 0 ((min x z) - y))) (+) 0 (ws :: A.Arr (Int,Int,Int))
              -- in ws
    where
      x = lengthS xs
      f' i | i == 0     = (0, nthS xs i, nthS xs (i + 1))
           | i == x - 1 = (nthS xs (i - 1), nthS xs i, 0)
           | otherwise  = (nthS xs (i - 1), nthS xs i, nthS xs (i + 1))
      g (x,y,z) (x',y',z') = (max x x', y', max z z')

{- Ejercicio 4 -}
matchParen :: Seq s => s Paren -> Bool
matchParen xs = let ys = mapS parenToInt xs
                    (zs, z) = scanS (+) 0 ys
                in (reduceS min 0 zs == 0) && (z == 0)
    where
      parenToInt Open = 1
      parenToInt Close = -1

{- Ejercicio 5 -}

sccml :: Seq s => s Int -> Int
sccml xs = let
              ys = mapS (\x -> (x,x,1,1)) xs
              (zs, z) = scanS cmb (minBound, minBound, 0, 0) ys
              ws = mapS ext zs
           in reduceS max (ext z) ws
    where
      ext (_, _, _, x) = x
      cmb (p1, u1, l1, s1) (p2, u2, l2, s2) = if u1 < p2 && l2 == s2 then (p1, u2, l1+l2, s1+s2)
                                              else (p1, u2, l1+l2, s2)

{- Ejercicio 6 -}
cantMultiplos :: Seq s => s Int -> Int
cantMultiplos xs = let ys = tuplasMultiplos xs
                       zs = mapS multiplos ys
                   in reduceS (+) 0 zs
    where
      tuplasMultiplos :: Seq s => s Int -> s (Int, s Int)
      tuplasMultiplos ys = tabulateS (\i -> (nthS ys i, dropS ys (i + 1))) ((lengthS ys) - 1)
      multiplos (n, ys) = lengthS (filterS (\y -> (mod n y) == 0) ys)

-- f :: Ord a => a -> a -> Ordering
-- f x y = if x < y then LT else GT

splitBy :: Seq s => (a -> a -> Ordering) -> a -> s a -> (s a, s a)
splitBy cmp v xs = let
                      ys = tabulateS g (lengthS xs)
                      i = reduceS (+) 0 (ys :: A.Arr Int)
                   in (takeS xs i, dropS xs i)
    where
      -- g i = if (cmp v (nthS xs i)) == LT then 0 else 1
      g i = if (cmp v (nthS xs i)) == LT || (cmp v (nthS xs i)) == EQ then 0 else 1

mergeBy' :: Seq s => (a -> a -> Ordering) -> s a -> s a -> s a
mergeBy' cmp xs ys = case showtS xs of
                    EMPTY -> ys
                    ELT v -> let (l, r) = splitBy cmp v ys
                             in l `appendS` (singletonS v) `appendS` r
                    NODE l r -> let
                                    (l', r') = splitBy cmp (nthS r 0) ys
                                    (xs', ys') = (mergeBy' cmp l l') ||| (mergeBy' cmp r r')
                                  in xs' `appendS` ys'

sortS' :: Seq s => (a -> a -> Ordering) -> s a -> s a
sortS' cmp xs = case showtS xs of
                  NODE l r -> let
                                (ys, zs) = (sortS' cmp l) ||| (sortS' cmp r)
                              in mergeBy' cmp ys zs
                  _ -> xs

-- maxS :: Seq s => (a -> a -> Ordering) -> s a -> Int
-- maxS cmp xs = let
--                 ys = tabulateS (\i -> (nthS xs i, i)) (lengthS xs)
--                 (_, i) = reduceS g (nthS ys 0) ys
--               in i
--     where
--       g x@(v, _) y@(v', _) = if cmp v v' == LT then y else x

groupS :: Seq s => (a -> a -> Ordering) -> s a -> s a
groupS cmp xs = let
                  ys = mapS singletonS xs
                in reduceS combinar emptyS ys
    where
      combinar zs ws | (lengthS zs) == 0  = ws
                     | (lengthS ws) == 0  = zs
                     | otherwise          = if cmp (nthS zs ((lengthS zs) - 1)) (nthS ws 0) == EQ
                                              then appendS zs (dropS ws 1)
                                            else appendS zs ws

-- collectS :: Seq s => (a -> a -> Ordering) -> s (a, b) -> s (a, s b)
-- collectS f xs = let
--                   ys = mapS (\(x,y) -> (x,singletonS y)) xs
--                   zs = sortS (\(x,_) (y,_) -> f x y) ys
--                 in reduceS comb emptyS zs
--     where
--       comb s1 s2 | lengthS s1 == 0  = s2
--                  | lengthS s2 == 0  = s1
--                  | otherwise        = let
--                                         lastL = nthS s1 ((lengthS s1) - 1)
--                                         firstR = nthS s2 0
--                                       in if (f lastL firstR) == EQ
--                                       then (takeS s1 (lengthS s1 - 1)) `appendS` singletonS (fst lastL, (appendS (snd lastL) (snd firstR))) `appendS` dropS s2 1
--                                          else appendS s1 s2
group' :: Ord a => Seq s => s (a, b) -> s (a, s b)
group' s = 
  let ss = mapS (\(i, j) -> singletonS (i, singletonS j)) s
  in reduceS comb emptyS ss 
  where
    comb l r
      | lengthS l == 0 = r
      | lengthS r == 0 = l
      | otherwise = if (cmp lastL firstR) == EQ then (takeS l (lengthS l - 1)) `appendS` singletonS (fst lastL, (appendS (snd lastL) (snd firstR))) `appendS` dropS r 1
                    else appendS l r
                    where lastL = nthS l ((lengthS l) - 1)
                          firstR = nthS r 0
                          cmp (a, _) (c, _) = compare a c 

-- collect (fromList [(2, "a"), (1, "b"), (1, "c"), (2, "d")] :: A.Arr (Int, String))
collectS :: (Seq s, Ord a) => (a -> a -> Ordering) -> s (a, b) -> s (a, s b)
collectS cmp xs = let ys = sortS' (\(x,_) (y,_) -> cmp x y) xs
                 in group' ys
