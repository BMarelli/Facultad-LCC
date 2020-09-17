import Seq
import ArrSeq
import qualified Arr as A

-- Ejercicio 1
data PHeaps a = Empty | Root a [PHeaps a]
                deriving Show

type MultiMap a b = PHeaps (a, [b])

{-
size Empty = 0
size (put Empty (a,b)) = 1
size (put m (a,b)) = 1 + size m

values Empty = []
values (put Empty (a,b)) a = [b]
values (put m (a,b)) a = [b] U values m (a,b)
values (put Empty (a,b)) k = []
values (put m (a,b)) k = [] U values m (a,b)

delete (put Empty (a,b)) (a,b) = Empty
delete Empty (a,b) = Empty
delete (put m (a,b)) (a,b) = m
-}

m1 = Root (1, ["a", "c"]) [(Root (2, ["b"]) [Empty]), (Root (3,["a"]) [Empty])]
m2 = Root (2, ["c"]) [(Root (3, ["c", "d"]) [Empty]), (Root (4, ["e"]) [Empty])]

mergeMultimap :: Ord a => MultiMap a b -> MultiMap a b -> MultiMap a b
mergeMultimap Empty Empty = Empty
mergeMultimap Empty ms = ms
mergeMultimap ms Empty = ms
mergeMultimap m1@(Root (k1, xs1) ms1) m2@(Root (k2, xs2) ms2) | k1 < k2     = Root (k1, xs1) (m2 : ms1)
                                                              | k2 < k1     = Root (k2, xs2) (m1 : ms2)
                                                              | otherwise   = Root (k1, xs1 ++ xs2) (ms1 ++ ms2)

mergeMultimapL :: Ord a => [MultiMap a b] -> MultiMap a b
mergeMultimapL [] = Empty
mergeMultimapL (x:xs) = mergeMultimap x (mergeMultimapL xs) 

values :: Ord a => MultiMap a b -> a -> [b]
values Empty _ = []
values (Root (k, xs) ms) v | k > v     = []
                           | k == v    = xs ++ (values (mergeMultimapL ms) v)
                           | otherwise = (values (mergeMultimapL ms) v)

minKey :: Ord a => MultiMap a b -> [b]
minKey Empty = []
minKey (Root (k, xs) ms) = xs ++ (values (mergeMultimapL ms) k)

delete :: Ord a => Eq b => (a, b) -> MultiMap a b -> MultiMap a b
delete _ Empty = Empty
delete (k', v) m@(Root (k, xs) ms) | k > k'    = m
                                   | k < k'    = Root (k, xs) (Prelude.map (delete (k', v)) ms)
                                   | otherwise = Root (k, [x | x <- xs, x /= v]) (Prelude.map (delete (k', v)) ms)

-- Ejercicio 2
ventas :: Seq s => s Float -> Float -> (s Float, Float)
ventas xs k = let
                (ys, y) = scanS f k xs
                zs = dropS ys 1
              in if (nthS zs 0) >= k then (zs, nthS zs 0) else (zs, -1)
    where
      f x y = if x < y then y else x
