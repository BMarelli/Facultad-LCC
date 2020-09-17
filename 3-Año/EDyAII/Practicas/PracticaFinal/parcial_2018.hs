import Seq
import Par
import qualified Arr as A
import ListSeq
import ArrSeq

data Tree k v = E | N Int (Tree k v) (k, v) (Tree k v) deriving Show

inorder :: Tree k v -> [(k, v)]
inorder E = []
inorder (N _ xs v ys) = (inorder xs) ++ [v] ++ (inorder ys)

splitMax :: Ord k => Tree k v -> ((k, v), Tree k v)
splitMax (N _ E (k, v) E) = ((k, v), E)
splitMax (N n l (k, v) E) = ((k, v), l)
splitMax (N n l (k, v) r) = let (par, r') = splitMax r 
                            in (par, N n l (k, v) r')

delete :: Ord k => Tree k v -> k -> Tree k v
delete E _ = E
delete bt@(N n E (k, v) E) x = if x == k then E else bt 
delete (N n xs (k, v) ys) x | k > x     = N (n - 1) (delete xs x) (k, v) ys
                            | k < x     = N (n - 1) xs (k, v) (delete ys k)
                            | otherwise = let (m, l) = splitMax xs
                                          in N (n - 1) l m ys

{-
P : t BST, takeMax t n es un BST \forall n

Caso Base:
takeMax E = E

Caso Inductivo: Sea t@(N i xs v ys), supongamos que P vale para xs y P vale para ys con n
Veamos si P vale para t con n

takeMax t n
{ def takeMax | sr = size xs}
{ sr == n } => xs Vale

{ sr > n} => takeMax xs n => { HI } vale
{ sr < n }
N n (takeMax xs (n - sr - 1)) v ys
{ HI } => takeMax xs (n - sr - 1) es BST y ys es BST => N n (takeMax xs (n - sr - 1)) v ys es BST
QED
-}

-- Ejericicio 2

exclamationsOks :: Seq s => s Char -> Bool
exclamationsOks xs = let
                        ys = mapS (exclamations2Int) xs
                        (zs, z) = scanS (+) 0 ys
                     in (reduceS min 0 zs == 0) && (z == 0)
    where
      exclamations2Int :: Char -> Int
      exclamations2Int '!' = -1
      exclamations2Int '¡' = 1
      exclamations2Int _ = 0
