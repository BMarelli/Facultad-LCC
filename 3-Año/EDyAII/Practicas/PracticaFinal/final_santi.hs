import Seq
import Par
import qualified Arr as A
import ListSeq
import ArrSeq

acuerdo :: (Seq s) => s Int -> Int -> Int -> Int
acuerdo xs x k = let (ys, y) = scanS (+) 0 xs
                     ws = appendS (dropS ys 1) (singletonS y)
                     zs = filterS (< x) ws
                     len = lengthS xs
                     lenz = lengthS zs
                     cs = tabulateS (\i -> if i < lenz then nthS xs i else k) len
                     rs = reduceS (+) 0 (cs :: A.Arr Int)
                 in rs

data Tree a = E | N Int (Tree a) a (Tree a) deriving Show

-- TODO:

inorder :: Tree a -> [a]
inorder E = []
inorder (N _ xs v ys) = (inorder xs) ++ [v] ++ (inorder ys)

size :: Tree a -> Int
size E = 0
size (N n _ _ _) = n

dropWhileEnd :: (a -> Bool) -> Tree a -> Tree a
dropWhileEnd _ E = E
dropWhileEnd p (N _ xs v ys) = let ((l, r), x) = (dropWhileEnd p xs ||| dropWhileEnd p ys) ||| p v
                               in if x then case l of
                                                E -> r
                                                _ -> N (size l + size ys) l v ys
                                  else N (size l + size ys) l v ys
