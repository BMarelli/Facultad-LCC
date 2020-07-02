import Par

tabulateS :: (Int -> a) -> Int -> [a]
tabulateS f 0 = []
tabulateS f n = tabulateS' f n 0
                where
                    tabulateS' f 0 _ = []
                    tabulateS' f n i =  let
                                            (x,xs) = f i ||| tabulateS' f (n-1) (i+1)
                                        in x : xs

contract :: (a -> a -> a) -> [a] -> [a]
contract _ [] = []
contract _ [x] = [x]
contract f (x:y:xs) = let (z, zs) = f x y ||| contract f xs
                      in z:zs
reduceS :: (a -> a -> a) -> a -> [a] -> a
reduceS _ e [] = e
reduceS f e [x] = f e x
reduceS f e xs = let ctr = contract f xs
                     ys = reduceS f e ctr
                 in id ys

scanS :: (a -> a -> a) -> a -> [a] -> ([a], a)
scanS _ e [] = ([], e)
scanS f e [x] = ([e], f e x)
scanS f e xs = let ctr = contract f xs
                   (ys, y) = scanS f e ctr
               in (buildList f xs ys False, y)
      where 
        buildList f [] _ _ = []
        buildList f _ [] _ = []
        buildList f [x] [y] _ = [y]
        buildList f l1@(x:z:xs) l2@(y:ys) flag  | flag         = (f y x) : buildList f xs ys False
                                                | otherwise    = y : buildList f l1 l2 True

promedios :: [Int] -> [Float]
promedios xs = let (ys, y) = scanS (+) 0 xs
                   zs = (drop 1 ys) ++ [y]
               in tabulateS (\x ->  (zs !! x) / x) (length zs)

mayores :: [Int] -> Int
mayores xs = let (ys, y) = scanS maximo minBound xs
                 zs = (drop 1 ys) ++ [y]
             in sum (tabulateS (\i -> if (xs !! i) == (zs !! i) then 1 else 0) (length zs)) - 1
    where
      maximo a b = if a == b then minBound else max a b
