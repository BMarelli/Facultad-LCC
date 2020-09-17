{- Ejercicio 1 -}

data BTree a = Empty | Node Int (BTree a) a (BTree a)
              deriving Show

size :: BTree a -> Int
size Empty = 0
size (Node n _ _ _) = n

-- Calcula el n-esimo elemnto de una secuencia
nth :: BTree a -> Int -> a
nth Empty _ = error "Invalid index"
nth (Node k xs v ys) n | x == n        = v
                       | x > n         = nth xs n
                       | otherwise     = nth ys (n - x - 1)
                where x = size xs

-- Inserta un elemento al comienzo de la secuencia
cons :: a -> BTree a -> BTree a
cons v Empty = Node 1 Empty v Empty
cons v (Node k xs x ys) = Node (k + 1) (cons v xs) x ys

-- Dada una funcion f y un entero n devuelve una secuencia de tamaño n,
-- donde cada elemento de la secuencia es el resultado de aplicar f al indice del elemento
tabulate :: (Int -> a) -> Int -> BTree a
tabulate f 0 = Empty
tabulate f n = let mid = div n 2
                   (xs, ys) = (tabulate f mid, tabulate (\x -> f (x + mid + 1)) (n - mid - 1))
                in Node n xs (f mid) ys

-- Dada una funcion f y una secuencia s, devuelve el resultado de aplicar f sobre cada elemento de s.
map_ :: (a -> b) -> BTree a -> BTree b
map_ _ Empty = Empty
map_ f (Node k xs v ys) = Node k (map_ f xs) (f v) (map_ f ys)

-- Ddados un entero n y una secuencia s devuelve los primeros n elementos de s
take_ :: Int -> BTree a -> BTree a
take_ 0 _ = Empty
take_ _ Empty = Empty
take_ n tr@(Node k xs v ys) | k <= n       = tr
                            | x == n       = xs
                            | x > n        = take_ n xs
                            | otherwise    = Node n xs v (take_ (n - x - 1) ys)
                      where x = size xs

-- Dados un entero n y una secuencia s devuelve la secuencia s sin los primeros n elementos.
drop_ :: Int -> BTree a ->  BTree a
drop_ 0 xs = xs
drop_ _ Empty = Empty
drop_ n (Node k xs v ys) | k <= n         = Empty
                         | x == n         = ys
                         | x > n          = drop_ (n - x) ys
                         | otherwise      = Node (n - k) xs v (drop_ (n - x - 1) ys)
                      where x = (size xs) + 1

{- Ejercicio 2 -}
data Tree a = E | Leaf a | Join (Tree a) (Tree a)
              deriving Show

mapreduce :: (a -> b) -> (b -> b -> b) -> b -> Tree a -> b
mapreduce f g n = mr
    where 
      mr E              = n
      mr (Leaf v)       = f v
      mr (Join xs ys)   = let (l, r) = (mr xs, mr ys) in g l r

-- Dada una secuecia, calcula la maxima suma de una subsecuencia contigua
mcss :: (Num a, Ord a) => Tree a -> a
mcss = (\(m, _, _, _) -> m) . mapreduce f g n
    where
      f x = (max x 0, max x 0, max x 0, x)
      g (m1, p1, s1, t1) (m2, p2, s2, t2) = (max (max m1 m2) (s1 + p2), max p1 (t1 + t2), max s2 (t2 + s1), t1 + t2)
      n = (0, 0, 0, 0)

{- Ejercicio 3 -}
reduceT :: (a -> a -> a) -> a -> Tree a -> a
reduceT _ e E = n
reduceT f e (Leaf v) =f e v
reduceT f e (Join xs ys) = let (l, r) = (reduceT f e xs, reduceT f e ys)
                           in f l r

sufijos :: Tree Int -> Tree (Tree Int)
sufijos t = sufijos_ t E
      where
        sufijos_ E _                = Leaf E
        sufijos_ (Leaf _) zs        = Leaf zs
        sufijos_ (Join xs ys) zs    = let (l, r) = case zs of
                                                      E -> (sufijos_ xs ys, sufijos_ ys E)
                                                      _ -> (sufijos_ xs (Join ys zs), sufijos_ ys zs)
                                      in Join l r 

conSufijos :: Tree Int -> Tree (Int, Tree Int)
conSufijos E = E
conSufijos t = let suf = sufijos t
               in conSufijos_ t suf
        where
          conSufijos_ (Leaf v) (Leaf v') = Leaf (v, v')
          conSufijos_ (Join xs ys) (Join xs' ys') = let (l, r) = (conSufijos_ xs xs', conSufijos_ ys ys')
                                                    in Join l r

maxT :: Tree Int -> Int
maxT t = reduceT max minBound t

maxAll :: Tree (Tree Int) -> Int
maxAll t = mapreduce maxT max minBound t

-- mejorGanancia :: Tree Int -> Int
-- mejorGanancia t = maxAll (conSufijos t)

{- Ejercicio 4 -}
data T a = E' | N (T a) a (T a)
          deriving Show

altura :: T a -> Int
altura E' = 0
altura (N xs _ ys) = 1 + max (altura xs) (altura ys) 

combinar :: T a -> T a -> T a
combinar E' t2 = t2
combinar t1 E' = t1
combinar (N xs v ys) t = N (combinar xs ys) v t 

filterT :: (a -> Bool) -> T a -> T a
filterT p E' = E'
filterT p (N xs v ys) = let (l, r) = (filterT p xs, filterT p ys)
                        in if p v then N l v r
                           else combinar l r
                        
quickSortT :: T Int -> T Int
quickSortT E' = E'
quickSortT (N xs v ys) = let (l, r) = (combinar (filterT (<= v) xs) (filterT (<= v) ys),
                                       combinar (filterT (>= v) xs) (filterT (>= v) ys))
                         in N l v r

{- Ejercicio 5 -}
splitAt_ :: BTree a -> Int -> (BTree a, BTree a)
splitAt_ t n = (take_ n t, drop_ n t)
