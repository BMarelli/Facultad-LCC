import Prelude hiding (mapM)
-- Ejercicio 1
newtype Pair a = P (a, a)

instance Functor Pair where
  fmap f (P (x, y)) = P (f x, f y)

{-
< functor.1 >
fmap id (P (x, y)) = P (id x, id y) = P (x, y) = id (P (x, y))

< functor.2 >
fmap f . fmap g (P (x, y)) = fmap f (P (g x, g y)) = P (f.g x, f.g y) = fmap (f.g) (P (x, y))

-}

data Tree a = Empty | Branch a (Tree a) (Tree a)

instance Functor Tree where
  fmap _ Empty = Empty
  fmap f (Branch v l r) = Branch (f v) (fmap f l) (fmap f r)

{-
< functor.1 >
fmap id Empty = Empty = id Empty
fmap id (Branch v l r) = Branch (id v) (fmap id l) (fmap id r) = Branch v (fmap id l) (fmap id r) =HI= (Branch v l r)
id (Branch v l r) = (Branch v l r)

< functor.2 >
fmap f . fmap g (Branch v l r) = fmap f (Branch (g v) (fmap g l) (fmap g r)) =
= (Branch (f.g v) (fmap f . fmap g l) (fmap f . fmap g r)) =HI= (Branch (f.g v) (fmap f.g l) (fmap f.g r)) =
= fmap f.g (Branch v l r

-}

data GenTree a = Gen a [GenTree a]

instance Functor GenTree where
  fmap f (Gen v ts) = Gen (f v) (map (fmap f) ts)

data Cont a = C ((a -> Int) -> Int)

instance Functor Cont where
  fmap f (C g) = C (\h -> g (h.f))

-- Ejercicio 9
mapM :: Monad m => (a -> m b) -> [a] -> m [b]
mapM f [] = return []
mapM f (x:xs) = do x' <- f x
                   xs' <- mapM f xs
                   return (x':xs')

foldM :: Monad m => (a -> b -> m a) -> a -> [b] -> m a
foldM f e [] = return e
foldM f e (x:xs) = do x' <- f e x
                      foldM f x' xs

-- Ejercicio 10
ejercicio_10 :: Monad m => m t1 -> (t1 -> m t2) -> (t2 -> m t3) -> (t3 -> m b) -> m b
ejercicio_10 m h f g = do x <- m
                          y <- h x
                          z <- f y
                          g z

-- Ejercicio 11
{-
(y >>= (\z -> (f z >>= \w -> return (g w z)))) >>= \y -> if y then return 7 else (h x 2) >>= (\y -> return (k z))
-}

-- Ejercicio 12
{-
< monad.1 >
do x <- return a
   f x
=
f a

< monad.2 >
do x <- t
   return x
=
t

< monad.3 >
do x <- t
   y <- f x
   g y
=
do x <- t
   do y <- f x
      g y

-}

-- Ejercicio 13
holaMundo :: IO ()
holaMundo = print "Hola mundo"

-- Ejercicio 14
game :: IO ()
game = do print "Numero?"
          c <- getLine  
          loop c
    where
      win = print "Win!"
      loop c = do print "Player:>"
                  ss <- getLine
                  if ss == c then win
                  else print "Try again!" >> loop c

