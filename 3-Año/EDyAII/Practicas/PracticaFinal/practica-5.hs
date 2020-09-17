data BTree a = Empty | Node Int (BTree a) a (BTree a) deriving Show

sizeBT :: BTree a -> Int
sizeBT Empty = 0
sizeBT (Node k _ _ _) = k

nthBT :: Ord a => BTree a -> Int -> a
nthBT Empty _ = error "Invalid"
nthBT (Node k xs v ys) n | x == n     = v
                         | x > n      = nthBT xs n
                         | otherwise  = nthBT ys (n - x - 1)
    where
      x = sizeBT xs

consBT :: a -> BTree a -> BTree a
consBT v Empty = Node 1 Empty v Empty
consBT v (Node k xs x ys) = Node (k + 1) (consBT v xs) x ys

tabulateBT :: (Int -> a) -> Int -> BTree a
tabulateBT _ 0 = Empty
tabulateBT f n = let
                    m = div n 2
                    (l, r) = (tabulateBT f m, tabulateBT (\i -> f (i + m + 1)) (n - m - 1))
                 in Node n l (f m) r

mapBT :: (a -> b) -> BTree a -> BTree b
mapBT _ Empty = Empty
mapBT f (Node n xs v ys) = let (l, r) = (mapBT f xs, mapBT f ys)
                           in Node n l (f v) r


takeBT :: BTree a -> Int -> BTree a
takeBT Empty _ = Empty
takeBT bt@(Node k xs v ys) n | k <= n     = bt
                             | x == n     = xs
                             | x > n      = takeBT xs n
                             | otherwise  = takeBT ys (n - x - 1)
    where
      x = sizeBT xs

dropBT :: BTree a -> Int -> BTree a
dropBT Empty _ = Empty
dropBT bt 0 = bt
dropBT bt@(Node k xs v ys) n | k <= n       = Empty
                             | x == n       = Node (k - x) Empty v ys
                             | x > n        = Node (k - n) (dropBT xs n) v ys
                             | otherwise    = dropBT ys (n - x - 1)
    where
      x = (sizeBT xs)


-- Ejercicio 4
data T a = E | N (T a) a (T a) deriving Show

t = N (N (N E 4 (N E (-1) E)) 1203 (N (N E 234 (N E 100 E)) 0 (N E 1 E))) 1021 (N (N E 2313 (N E 31231 E)) 1231203 (N (N E 2332134 (N E 110 E)) 420 (N E 113 E))) :: T Int

inorderT :: T a -> [a]
inorderT E = []
inorderT (N xs v ys) = (inorderT xs) ++ [v] ++ (inorderT ys)

altura :: T a -> Int
altura E = 0
altura (N xs v ys) = 1 + (max (altura xs) (altura ys))

combinar :: T a -> T a -> T a
combinar E ys = ys
combinar xs E = xs
combinar (N l v r) ys = N (combinar l r) v ys

filterT :: (a -> Bool) -> T a -> T a
filterT _ E = E
filterT f (N xs v ys) = let (l, r) = (filterT f xs, filterT f ys)
                        in if f v then N l v r
                           else combinar l r

quickSortT :: T Int -> T Int
quickSortT E = E
quickSortT (N xs v ys) = let (l, r) = (combinar (filterT (\i -> i <= v) xs) (filterT (\i -> i <= v) ys),
                                       combinar (filterT (\i -> i >= v) xs) (filterT (\i -> i >= v) ys))
                         in N (quickSortT l) v (quickSortT r)

-- Ejercicio 5
splitAt :: BTree a -> Int -> (BTree a, BTree a)
splitAt t n = (takeBT t n, dropBT n)
