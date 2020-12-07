import Seq
import Par
import qualified Arr as A
import ListSeq
import ArrSeq

acuerdo :: (Seq s) => s Int -> Int -> Int -> (Int, Float)
acuerdo xs x k = let (ys, y) = scanS (+) 0 xs
                     ws = appendS (dropS ys 1) (singletonS y)
                     zs = filterS (< x) ws
                     len = lengthS xs
                     lenz = lengthS zs
                     cs = tabulateS (\i -> if i < lenz then nthS xs i else k) len
                     rs = reduceS (+) 0 (cs :: A.Arr Int)
                 in (rs, fromIntegral(lenz) / fromIntegral(len) * 100)

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


data T a = Empty | Leaf a | Node (T a) (T a) deriving Show

sufijos :: T a -> T (T a)
sufijos t = sufijos_ t Empty
      where
        sufijos_ Empty _         = Leaf Empty
        sufijos_ (Leaf _) zs        = Leaf zs
        sufijos_ (Node xs ys) zs    = let (l, r) = case zs of
                                                      Empty -> (sufijos_ xs ys, sufijos_ ys Empty)
                                                      _ -> (sufijos_ xs (Node ys zs), sufijos_ ys zs)
                                      in Node l r

prefijos :: T a -> T (T a)
prefijos t = prefijos_ t Empty
      where
        prefijos_ Empty _             = Leaf Empty
        prefijos_ (Leaf _) zs     = Leaf zs
        prefijos_ (Node xs ys) zs    = let (l, r) = case zs of
                                                      Empty -> (prefijos_ xs Empty, prefijos_ ys xs)
                                                      _ -> (prefijos_ xs zs, prefijos_ ys (Node xs zs))
                                    in Node l r

partir :: T a -> T (T a, a, T a)
partir t = let pf = prefijos t
               sf = sufijos t
           in partir' t pf sf
    where
      partir' Empty _ _ = Empty
      partir' (Leaf v) (Leaf ps) (Leaf ss) = Leaf (ps, v, ss)
      partir' (Node xs ys) (Node ps1 ps2) (Node ss1 ss2) = let (l, r) = (partir' xs ps1 ss1, partir' ys ps2 ss2)
                                                           in Node l r

    
