module Final_facu where
data Tree a = E | L a | N (Tree a) (Tree a) deriving Show

esPrefijo :: Eq a => Tree a -> Tree a -> (Bool, Tree a)
esPrefijo E t2 = (True, t2)
esPrefijo _ E = (False, E)
esPrefijo (L v) t2@(L v') = if v == v' then (True, E) else (False, t2)
esPrefijo t1@(L _) t2@(N E ys') = esPrefijo t1 ys'
esPrefijo t1@(L _) t2@(N xs' ys') = case esPrefijo t1 xs' of
                                        (True, s) -> (True, N s ys')
                                        _ -> (False, t2)
esPrefijo (N xs ys) t2 = case esPrefijo xs t2 of
                            (True, s) -> esPrefijo ys s
                            _ -> (False, t2)

dropOneT :: Tree a -> Tree a
dropOneT (L _) = E
dropOneT (N E ys) = dropOneT ys
dropOneT (N xs ys) = let r = dropOneT xs in N r ys

esSubSeq :: Eq a => Tree a -> Tree a -> Bool
esSubSeq E _ = True
esSubSeq _ E = False
esSubSeq t1 t2 = case esPrefijo t1 t2 of
                    (True, _) -> True
                    (False, _) -> esSubSeq t1 (dropOneT t2)

t1 = N (N (N (L 1) (L 2)) (L 3)) (N (L 4) (L 5))
t2 = N (N (N (L 3) (L 4)) (N (L 1) (L 2))) (N (L 3) (N (N (L 3) (L 4)) (N (L 5) (L 6))))
t3 = N (L 1) (N (L 2) (L 3))
t4 = N (N (L 1) (L 2)) (L 3)

inorder :: Tree a -> [a]
inorder E = []
inorder (L v) = [v]
inorder (N xs ys) = inorder xs ++ inorder ys
