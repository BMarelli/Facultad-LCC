import Seq
import Par
import qualified Arr as A
import ListSeq
import ArrSeq

-- intereses :: Seq s => s Int -> Int -> (s (Int,Int,Int), (Int,Int,Int))
-- intereses :: Seq s => s Int -> Int -> Int
intereses :: Seq s => s Int -> Int -> s Int
intereses xs n = let
                    ys = mapS (\x -> (x,x)) xs
                    (zs, z) = scanS f (0,0) ys
                    ws = appendS (dropS zs 1) (singletonS z)
                --  in fst (reduceS g (0,0) ws)
                 in (zs,z)
    where
      f (v,s) (v',s') = if (s + v') < n then (v', s + v')
                        else (v, s + v')
      g (v,s) (v',s') = (v+v',s')


-- intereses xs n = let
--                     ys = tabulateS (\i -> (nthS xs i, nthS xs i, if i == 0 then 0 else nthS xs (i - 1))) len
--                     (zs, z) = scanS f (0,0,0) ys
--                     ws = appendS (dropS zs 1) (singletonS z)
--                 --  in (mapS g ws) 
--                 --  in mapreduceS g (+) 0 (ws :: A.Arr (Int,Int,Int))
--                  in (zs,z)
--     where
--       len = lengthS xs
--       f (v,s,u) (v',s',u') = if (s + v') <= n then (v', s + s',u')
--                         else (v, s + v',u)
--       g (v,s,u) = if s < n then v else u

data Tree a = E | N Int (Tree a) a (Tree a) deriving Show

t1 = N 4 (N 2 (N 0 E 2 E) 4 (N 0 E 1 E)) 3 (N 0 E 6 E)
t2 = N 5 (N 1 (N 0 E 1 E) 2 E) 3 (N 2 (N 0 E 4 E) 5 (N 0 E 6 E))

inorder :: Tree a -> [a]
inorder E = []
inorder (N _ xs v ys) = (inorder xs) ++ [v] ++ (inorder ys)

appendT :: Tree a -> Tree a -> Tree a
appendT E t2 = t2
appendT t1 E = t1
appendT (N k xs v ys) t2@(N k' _ _ _) = N (k + k') xs v (appendT ys t2)

-- N 4 (N 2 (N 0 E 2 E) 4 (N 0 E 1 E)) 3 (N 0 E 6 (N 5 (N 1 (N 0 E 1 E) 2 E) 3 (N 2 (N 0 E 4 E) 5 (N 0 E 6 E))))

size :: Tree a -> Int
size E = 0
size (N k _ _ _) = k

create :: (Int -> Bool) -> (Int -> a) -> Int -> Tree a
create p f 0 = E
create p f n = let
                  m = div n 2
                  (l, r) = (create p f m, create (\x -> p (x + m + 1)) (\x -> f (x + m + 1)) ((n - m - 1)))
               in if p m then N ((size l) + (size r) + 1) l (f m) r
                  else appendT l r

-- create :: (Int -> Bool) -> (Int -> a) -> Int -> Tree a
-- create _ _ 0 = E
-- create p f n = create' 0 (n - 1)
--     where
--       create' min max | min > max     = E
--                       | otherwise     = let
--                                           m = div (min + max) 2
--                                           (l, r) = create' min (m - 1) ||| create' (m+1) max
--                                         in if p m then N ((size l) + (size r) + 1) l (f m) r
--                                            else appendT l r

-- N 10 (N 5 (N 2 (N 1 E 0 E) 1 E) 2 (N 2 (N 1 E 3 E) 4 E)) 5 (N 4 (N 2 (N 1 E 6 E) 7 E) 8 (N 1 E 9 E))


{-
nuevoLado (v,w) (nuevoLado (w,v) bs) = nuevoLado (w,v) bs
nuevoLado (v,w) (nuevoLado (x,y) bs) = nuevoLado (x,y) (nuevoLado (v,w) bs)

camino v w nuevo = False
camino v w (nuevoLado (v,w) bs) = True
camino v w (nuevoLado (x,y) bs) = if v == x && w == y || v == y && w == x then True
                                  else (camino v )
-}

data GTree a = Node a [GTree a]
type Bosque a = [GTree a]

isVertex :: Ord a => a -> GTree a -> Bool
isVertex v (Node v' []) = (v == v')
isVertex v (Node v' xs) = if v == v' then True else or (map (isVertex v) xs)

esVertice :: Ord a => a -> Bosque a -> Bool
esVertice _ [] = False
esVertice v xs = or (map (isVertex v) xs)
      

esCamino :: Ord a => a -> a -> Bosque a -> Bool
esCamino _ _ [] = False
esCamino v w xs = or (map (isPath v w) xs)
    where
      isPath :: Ord a => a -> a -> GTree a -> Bool
      -- isPath v w (Node v' []) = v == v' || w == v'
      isPath v w (Node v' xs) | v == v'  = or (map (isVertex w) xs)
                              | w == v'  = or (map (isVertex v) xs)
