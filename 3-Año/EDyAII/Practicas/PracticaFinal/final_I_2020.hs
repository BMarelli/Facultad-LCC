import Seq
import ArrSeq
import qualified Arr as A

data Tree a = E | L a | N (Tree a) (Tree a)
              deriving Show

{- 
partir E = E
partir (L a) = L (E, a, E)
partir (N (L a) (L b)) = N (L (E, a, (L b))) (L ((L a), b, E))
partir (N (N (L a) (L b)) (L c)) = 
-}

t = N (N (L 1) (L 2)) (L 3)

partir :: Tree a -> Tree (Tree a, a, Tree a)
partir t = partir_ t (E, E)
    where
      partir_ E _ = E
      partir_ (L v) (xs, ys) = L (xs, v, ys)
      partir_ (N l r) (xs, ys) = N (partir_ l (xs, (N r ys))) (partir_ r (N xs l, ys))


-- Ejercicio 1
{-
join empty empty = empty
join empty ys = ys
join xs empty = xs
join xs (insert v ys) = insert v (join xs ys)

delete v empty = empty
delete v (insert x xs) = if v == x then xs else insert x (delete v xs)
-}

data BST a = Empty | Node (BST a) a (BST a) deriving Show

bt = Node (Node (Node Empty 2 Empty ) 3 (Node Empty 4 Empty)) 5 (Node (Node Empty 6 Empty) 7 (Node Empty 8 Empty))

delete :: (Ord a) => a -> BST a -> BST a
delete _ Empty = Empty
delete v (Node xs x ys) | v == x    = merge_ xs ys
                        | v < x     = Node (delete v xs) x ys
                        | otherwise = Node xs x (delete v ys)
    where
      merge_ :: (Ord a) => BST a -> BST a -> BST a
      merge_ Empty ys = ys
      merge_ xs Empty = xs
      merge_ xs@(Node l x r) ys@(Node l' y r') = if x < y then Node l x (merge_ r ys) else Node (merge_ xs l') y r'

split :: (Ord a) => a -> BST a -> (BST a, Maybe a, BST a)
split v Empty = (Empty, Nothing, Empty)
split v (Node xs x ys) | v == x    = (xs, Just x, ys)
                       | v < x      = let (l, y, r) = split v xs
                                      in (l, y, Node r x ys)
                       | otherwise  = let (l, y, r) = split v ys
                                      in (Node xs x l, y, r)

infoCo :: Seq s => s (Int, Int) -> (Int, s Int)
infoCo xs = let
              ys = mapS (\(x,y) -> x - y) xs
              (zs, z) = scanS (+) 0 ys
              ws = appendS (dropS zs 1) (singletonS z)
              w = maxS compare ys
            in (w + 1, ws)
