data BinTree a = Leaf | Bin a (BinTree a) (BinTree a) deriving Show

foldBin :: BinTree a -> b -> (a -> b -> b -> b) -> b
foldBin Leaf l b = l
foldBin (Bin a t u) l b = b a (foldBin t l b) (foldBin u l b)

isLeaf :: BinTree a -> Bool
isLeaf t = foldBin t True (\_ _ _ -> False)

mapBin :: (a -> b) -> BinTree a -> BinTree b
mapBin f t = foldBin t Leaf (\x l r -> Bin (f x) l r)

heightBin :: BinTree a -> Int
heightBin t = foldBin t 0 (\_ l r -> 1 + max l r)

mirrorBin :: BinTree a -> BinTree a
mirrorBin t = foldBin t Leaf (\x l r -> Bin x r l)

