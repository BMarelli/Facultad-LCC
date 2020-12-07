import Seq
import Par
import qualified Arr as A
import ListSeq
import ArrSeq

pagoDeuda :: Seq s => s (Int, Int) -> Int
pagoDeuda xs = let (ys, y) = scanS (\(x1, y1) (x2, y2) -> (x1+x2, y1+y2)) (0, 0) xs
                   ws = appendS (dropS ys 1) (singletonS y)
                   zs = tabulateS (\i -> let x = nthS ws i in (fst x, fst (nthS xs i) > snd x)) (lengthS ws)
                   ft = filterS (\(_, b) -> b) (zs :: A.Arr (Int, Bool))
                   len = lengthS ft
                   rt = tabulateS (\i -> let (_, d) = nthS xs i in (if i < len then d else snd (nthS xs (len-1)))) (lengthS xs)  
               in (fst y + (reduceS (+) 0 (rt :: A.Arr Int)))

data Tree a = E | N Int (Tree a) a (Tree a) deriving Show
size :: Tree a -> Int
size E = 0
size (N n _ _ _) = n

inorder :: Tree a -> [a]
inorder E = []
inorder (N _ xs v ys) = (inorder xs) ++ [v] ++ (inorder ys)

dropWhileT :: (a -> Bool) -> Tree a -> Tree a
dropWhileT _ E = E
dropWhileT p (N n xs v ys) = let ((l, r), b) = ((dropWhileT p xs ||| dropWhileT p ys) ||| p v)
                             in if b then case l of
                                            E -> r
                                            _ -> N (size l + size ys) l v ys
                                else N (size l + size ys) l v ys
t = N 5 (N 2 (N 1 E 1 E) 3 (N 1 E 5 E)) 4 (N 2 E 7 (N 1 E 8 E))
