{-
TODO: Consulta
- Ej 3
- Ej 10
- Ej 11 ( demostrar que Mk es Monada? )
- Ej 11 ( demostrar que StInt es Monada )

-}

import Control.Applicative (Applicative (..))
import Control.Monad (liftM ,ap)

-- Ejercicio 1
{-
newtype Id a = Id a

instance Monad Id where
  return x = Id x
  (Id x) >>= f = f x

----------------------------------------------------------------------------

< monad.1 >
return x >>= f
= { def.return }
(Id x) >>= f
= { def.>>= }
f x

< monad.2 >
(Id x) >>= return
= { def.>>= }
return x
= { def.return }
Id x

< monad.3 >
((Id x) >>= f) >>= g
= { def.>>= }
f x >>= g
= { def.>>= }
(Id x) >>= (\z -> f z >>= g)

----------------------------------------------------------------------------

data Maybe a = Nothing | Just a

instance Monad Maybe where
  return x = Just x
  Nothing >>= f = Nothing
  (Just x) >>= f = f x

----------------------------------------------------------------------------

< monad.1 >
return x >>= f
= { def.return }
(Just x) >>= f
= { def.>>= }
f x

< monad.2 >
Nothing >>= return
= { def.>>= }
Nothing

(Just x) >>= return
= { def.>>= }
return x
= { def.return }
Just x

< monad.3 >
(Nothing >>= f) >>= g
= { def.>>= }
Nothing >>= g
= { def. >>= }
Nothing
= { def. >>= }
Nothing >>= (\z -> f z >>= g)

((Just x) >>= f) >>= g
= { def.>>= }
f x >>= g
= { def.>>= }
(Just x) >>= (\z -> f z >>= g)

-}

-- Ejercicio 2
{-
instance Monad [] where
  return x = [x]
  xs >>= f = concat $ map f xs

< monad.1 >
return x >>= f
= { def.return }
[x] >>= f
= { def.>>= }
concat $ map f [x]
= { def. map }
concat [f x]
= { def.concat }
f x

< monad.2 >
xs >>= return
= { def.>>= }
concat $ map return xs
= { def.>>= }
concat [xs]
= {def.concat }
xs

< monad.3 > paja

-}

-- Ejercicio 3

newtype State s a = St {runState :: s -> (a, s)}

instance Monad (State s) where
  return x = St (\s -> (x, s))
  (St h) >>= f =
    St
      ( \s ->
          let (x, s') = h s
           in runState (f x) s'
      )

instance Functor (State s) where
  fmap = liftM

instance Applicative (State s) where
  pure = return
  (<*>) = ap


{-

< monad.1 >
return x >>= f
= { def.return }
St (\s -> (x, s)) >>= f
= { def.>>= }
St (\z -> let (x', s') = (\s -> (x, s)) z
          in runState (f x') s')
=
St (\z -> let (x', s') = (x, z)
          in runState (f x') s')
= { def.let }
St (\z -> runState (f x) z)
=
St (runState (f x))
= { St . runState = id }
f x

< monad.2 >
(St h) >>= return
= { def.>>= }
St (\s -> let (x, s') = h s
          in runState (return x) s')
= { def.return }
St (\s -> let (x, s') = h s
          in runState (St (\z -> (x, z)) s'))
= { def.runState }
St (\s -> let (x, s') = h s
          in (\z -> (x, z)) s')
=
St (\s -> let (x, s') = h s
          in (x, s'))
= { def.let }
St (\s -> (h s))
=
St h

< monad.3 >
((St h) >>= f) >>= g
= { def.>>= }
(St (\s -> let (x, s') = h s
           in runState (f x) s')) >>= g
= { def.>>= }
St (\z -> let (y, z') = (\s -> let (x, s') = h s in runState (f x) s') z
          in runState (g y) z')
=
St (\z -> let (y, z') = let (x, s') = h z in runState (f x) s'
          in runState (g y) z')
= { prop.let }
St (\z -> let (x, s') = h z in let (y, z') = runState (f x) s'
                               in runState (g y) z'))
=
{
St h' = f x
runState (f x) = runState (St h') = h'
}
=
St (\z -> let (x, s') = h z in let (y, z') = h' s'
                               in runState (g y) z'))
=
St (\z -> let (x, s') = h z in (\s' -> let (y, z') = h' s'
                                       in runState (g y) z')) s')
= { runState (St) = id}
St (\z -> let (x, s') = h z in runState (St (\s' -> let (y, z') = h' s'
                                                    in runState (g y) z')) s'))
=
St (\z -> let (x, s') = h z in runState ((St h') >>= g) s')
= { (St h') = f x }
St (\z -> let (x, s') = h z in runState ((f x) >>= g) s')
=
St (\z -> let (x, s') = h z in runState ((\x -> (f x) >>= g) x) s')
=
(St h) >>= (\x -> (f x) >>= g)

-}

set :: s -> State s () 
set s = St (\s -> ((), s))

get :: State s s
get = St (\s -> (s, s))

data Tree a = Leaf a | Branch (Tree a) (Tree a)

instance Functor Tree where
  fmap f (Leaf a) = Leaf (f a)
  fmap f (Branch l r) = Branch (fmap f l) (fmap f r)

numTree :: Tree a -> Tree Int
numTree t = fst (mapTreeNum update t 0)
    where
      update a n = (n, n+1)
      mapTreeNum :: (a -> Int -> (b, Int)) -> Tree a -> Int -> (Tree b, Int)
      mapTreeNum f (Leaf a) n = let (b, n') = f a n
                                in (Leaf b, n')
      mapTreeNum f (Branch l r) n = let (l', i) = mapTreeNum f l n
                                        (r', j) = mapTreeNum f r i
                                    in (Branch l' r', j)
      {-
      
      mapTreeNum :: (a -> s -> (b, s)) -> Tree a -> s -> (Tree b, s)
      mapTreeNum f (Leaf a) = do b <- f a
                                 return Leaf b
      mapTreeNum f (Branch l r) = do l' <- mapTreeNum l
                                     r' <- mapTreeNum r
                                     return (Branch l' r')
      
      -}

class Monoid m where
  mempty :: m
  mappend :: m -> m -> m

{-

class Monoid String where
  mempty = []
  mappend mempty ys = ys
  mappend (x:xs) ys = x:(mappend xs ys)

< asociativa >
mappend mempty (mappend ys zs)
= { def.mappend.1 }
mappend ys zs
= { def. mappend.1 }
mappend (mappend ys zs) mempty

mappend (mappend (x:xs) ys) zs
= { def.mappend.2 }
mappend (x:(mappend xs ys)) zs
= { def.mappend.2 }
x:(mappend (mappend xs ys) zs)
= { HI }
x:(mappend xs (mappend ys zs))
= { def.mappend.2 }
mappend (x:xs) (mappend ys zs)

< neutro.1 >
mappend mempty xs
= { def.mappend.1 }
xs

< neutro.2 >
mappend (x:xs) mempty
= { def.mappend.2 }
x:(mappend xs mempty)
= { HI }
x:xs

-}

-- Ejercicio 6
-- (a)
(>>) :: Monad m => m a -> m b -> m b
(>>) m1 m2 = m1 >>= (\_ -> m2)

-- (b) no es posible

-- Ejercicio 7
sequence' :: Monad m => [m a] -> m [a]
sequence' [] = return []
sequence' (x:xs) = do x' <- x
                      xs' <- sequence' xs
                      return (x':xs')

liftM' :: Monad m => (a -> b) -> m a -> m b
liftM' f m = m >>= return.f

liftM2' :: Monad m => (a -> b -> c) -> m a -> m b -> m c
liftM2' f m1 m2 = do x <- m1
                     y <- m2
                     return (f x y)

{- sequence' = foldr (liftM2' (:)) (return [])  -}

-- Ejercicio 8
data Error er a = Raise er | Return a

instance Monad (Error e) where
  return x = Return x
  (Return x) >>= f = f x
  (Raise er) >>= _ = Raise er

{-

< monad.1 >
return x >>= f
= { def.return }
Return x >>= f
= { def.>>=.1 }
f x

< monad.2 >
(Raise er) >>= return
= { def.>>=.2 }
Raise er

(Return x) >>= return
= { def.>>=.1 }
return x
= { def.return }
Return x

< monad.3 >
((Raise er) >>= f) >>= g
= { def.>>=.2 }
Raise er >>= g
= { def.>>=.2 }
Raise er

(Raise er) >>= (\x -> f x >>= g)
= { def.>>=.2 }
Raise er

(Return x >>= f) >>= g
= { def.>>=.1 }
f x >>= g

(Return x) >>= (\x -> f x >>= g)
= { def.>>=.1 }
(\x -> f x >>= g) x
=
f x >>= g

-}

head' :: [a] -> Error String a
head' [] = Raise "error!"
head' (x:_) = Return x

tail' :: [a] -> Error String [a]
tail' [] = Raise "error!"
tail' (_:xs) = Return xs

push :: a -> Error String [a] -> Error String [a]
push x p = do p' <- p
              return (x:p')

pop :: Error String [a] -> Error String (a, [a])
pop p = do p' <- p
           hd <- head' p'
           tl <- tail' p'
           return (hd, tl)

-- Ejercicio 9
data T = Const Int | Div T T
newtype M s e a = M { runM :: s -> Error e (a, s) }

instance Monad (M s e) where
  return x = M (\s -> Return (x, s))
  (M h) >>= f = M (\s -> let m = h s
                         in m >>= (\(x, s') -> runM (f x) s'))

raise :: String -> M a String a
raise er = M (\_ -> Raise er)

modify :: (a -> a) -> M a String ()
modify f = M (\s -> Return ((), f s))

eval :: T -> M Int String Int
eval (Const n) = return n
eval (Div t1 t2) = eval t1 >>= (\v1 -> 
                    eval t2 >>= (\v2 -> 
                      if v2 == 0 then raise "Error: Division por 0"
                      else modify (+1) Prelude.>> return (div v1 v2)))

-- Ejercicio 10
data Cont r a = Cont ((a -> r) -> r)

instance Monad (Cont r) where
  return x = Cont (\f -> f x)
  (Cont h) >>= f = Cont (\g -> h (\a -> let Cont y = f a
                                   in y g))

{-

< monad.1 >
return x >>= g
= { def.return }
Cont (\f -> f x) >>= g
= { def.>>= }
Cont (\h -> (\f -> f x) (\a -> let Cont y = g a
                               in y h))
=
Cont (\h -> (\a -> let Cont y = g a in y h) x)
=
Cont (\h -> let Cont y = g x in y h)
= { def.let }
Cont (\h -> let Cont y = g x in y h)

-}

-- -- Ejercicio 11
data Mk m a = Mk (m (Maybe a))

instance Monad m => Monad (Mk m) where
  return x = Mk (return (Just x))
  (Mk h) >>= f = Mk (do m <- h
                        case m of
                          Nothing -> return Nothing
                          Just x -> let Mk y = f x in y)

instance Monad m => Functor (Mk m) where
    fmap = liftM

instance Monad m => Applicative (Mk m) where
    pure = return
    (<*>) = ap

throw :: Monad m => Mk m a
throw = Mk (return Nothing)

data StInt a = StInt (Int -> (a, Int))
type N a = Mk StInt a

instance Monad StInt where
  return x = StInt (\s -> (x,s))
  (StInt h) >>= f = StInt (\s -> let (x, s') = h s
                                     StInt f' = f x
                                 in f' s')
  -- (StInt h) >>= f = StInt (\s -> let (x, s') = h s
  --                                in runState (f x) s')

instance Functor StInt where
    fmap = liftM

instance Applicative StInt where
    pure = return
    (<*>) = ap

{-

< monad.1 >
return x >>= f
= { def.return }
StInt (\s -> (x, s)) >>= f
= { def.>>= }
StInt (\z -> let (y, z') = (\s -> (x, s)) z
                 StInt f' = f y
             in f' z')
=
StInt (\z -> let (y, z') = (x, z)
                 StInt f' = f y
             in f' z')
= { def.let }
StInt (\z -> let StInt f' = f x
             in f' z)
=
{

f x = StInt f'
f' = foo (f x)
foo (StInt f') = f'

}
=
StInt (\z -> let StInt f' = f x
             in (foo (f x)) z)
= { def.let }
StInt (foo (f x)) 
= 
StInt f' 
= { let }
f x


-}

getN :: N Int
getN = Mk (StInt (\s -> (Just s,s)))

putN :: Int -> N ()
putN n = Mk (StInt (\_ -> (Just (), n)))

data Expr = Var
          | Con Int
          | Let Expr Expr
          | ADD Expr Expr
          | DIV Expr Expr
          deriving Show

evalN :: Expr -> N Int
evalN Var = getN
evalN (Con n) = return n
evalN (Let exp1 exp2) = do exp1' <- evalN exp1
                           putN exp1'
                           evalN exp2
evalN (ADD exp1 exp2) = do exp1' <- evalN exp1
                           exp2' <- evalN exp2
                           return (exp1' + exp2')
evalN (DIV exp1 exp2) = do exp1' <- evalN exp1
                           exp2' <- evalN exp2
                           if exp2' == 0 then throw else return (div exp1' exp2')


