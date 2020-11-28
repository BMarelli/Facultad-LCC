import Seq
import Par
import qualified Arr as A
import ListSeq
import ArrSeq

intereses :: Seq s => s Int -> Int -> Int
-- intereses :: Seq s => s Int -> Int -> Int
-- intereses xs k = let ys = mapS (\x -> (x,x)) xs
--                      (ws, w) = scanS f (nthS ys 0) (dropS ys 1)
--                      zs = appendS ws (singletonS w)
--                 in fst (reduceS g (0,0) zs)
--     where
--       f (v, s) (v', s') = if (s + v') < k then (v', s + s')
--                           else (v, s + s')
--       g (v, s) (v', s') = (v+v',s')

intereses xs k = let (ys, y) = scanS (+) 0 xs
                     ws = appendS (dropS ys 1) (singletonS y)
                     zs = filterS (\x -> x < k) ws
                     i = lengthS zs
                     cs = tabulateS (\x -> if x < i then nthS xs x else 0) (lengthS xs)
                 in if i == 0 then 0 
                    else reduceS (+) 0 (cs :: A.Arr Int) + (((lengthS xs) - i) * (nthS xs (i - 1)))

data Tree a = E | N Int (Tree a) a (Tree a) deriving Show

t1 = N 4 (N 2 (N 0 E 2 E) 4 (N 0 E 1 E)) 3 (N 0 E 6 E)
t2 = N 5 (N 1 (N 0 E 1 E) 2 E) 3 (N 2 (N 0 E 4 E) 5 (N 0 E 6 E))

inorder :: Tree a -> [a]
inorder E = []
inorder (N _ xs v ys) = (inorder xs) ++ [v] ++ (inorder ys)

size :: Tree a -> Int
size E = 0
size (N n _ _ _) = n

getLast :: Tree a -> (a, Tree a)
getLast t = get' t E
    where
      get' (N _ E v E) t2 = (v, t2)
      get' (N n l v r) t2 = get' l (N n r v t2)

-- appendT :: Tree a -> Tree a -> Tree a
-- appendT t1 E = t1
-- appendT E t2 = t2
-- appendT t1 (N n l v r) = let r' = (appendT l r)
--                          in N (1 + max (size r') (size t1)) t1 v r'

first :: Tree a -> (a,Tree a)
first (N _ E x E) = (x,E)
first (N i l x r) = let (v,l') = first l in (v,N (i-1) l' x r)

appendT :: Tree a -> Tree a -> Tree a
appendT xs E = xs
appendT E xs = xs
appendT xs ys = let (v,ys') = first ys in N (size xs + size ys) xs v ys'

-- combinar :: Tree a -> Tree a -> Tree a
-- combinar E t2 = t2
-- combinar t1 E = t1
-- combinar (N n xs v ys) t = let l' = (combinar xs ys)
--                            in N (1 + max (size l') (size t)) l' v t

-- create :: (Int -> Bool) -> (Int -> a) -> Int -> Tree a
-- create p f n = create' 0 (n-1)
--     where
--       create' min max | min < max = E
--                       | otherwise = let mid = div (min + max) 2
--                                         (l, (x, r)) = create' min (mid - 1) ||| (p mid ||| create (mid + 1) max)
--                                     in if x then N ((size l) + (size r) + 1) l (f mid) r
--                                        else appendT l r
