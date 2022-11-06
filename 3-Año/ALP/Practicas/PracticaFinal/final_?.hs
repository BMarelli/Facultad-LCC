import Control.Applicative (Applicative (..))
import Control.Monad (liftM ,ap)
import Data.Maybe

{-

Pair X Y = /\Z. (X -> Y -> Z) -> Z
List X = /\Y. (X -> Y -> Y) -> Y -> Y

unZip :: [(a, b)] -> ([a],[b])
unZip [] = ([],[])
unZip (x:xs) = let (ys, zs) = unZip xs
               in ((fst x):ys, (snd x):zs)

unZip xs = foldr (\y r -> ((fst y):(fst r),(snd y):(snd r))) ([],[]) xs

-- Lambda no tipado
unZip = \xs. xs (\y r. pair (cons (fst y) (fst r)) (cons (snd y) (snd r))) (pair nil nil)

-- Lambda tipado
unZip : \forall X. \forall Y. List (Pair X Y) -> Pair (List X) (List Y)
unZip = /\X. /\Y. \xs:List (Pair X Y).
  xs<Pair (List X) (List Y)>
  (\y:Pair X Y. \r:Pair (List X) (List Y). 
    pair<List X><List Y> (cons<X> (fst<X><Y> y) (fst<List X><List Y> r)) (cons<Y> (snd<X><Y> y) (snd<List X><List Y> r)))
  (pair<List X><List Y> nil<X> nil<Y>)

-}

newtype State s a = St { runSt :: s -> (a,s) }

class Kleisli m where
  ret :: a -> m a
  (>=>) :: (a -> m b) -> (b -> m c) -> (a -> m c)

instance Kleisli (State s) where
  ret x = St (\s -> (x, s))
  f >=> g = \x -> St (\s -> let (x', s') = runSt (f x) s
                             in runSt (g x') s')

-- instance Monad m => Kleisli m where
--   ret x = return x
--   f >=> g = 


newtype Writer w a = Writer { runWriter :: (a,[w]) }

instance Monad (Writer w) where
  return a = Writer (a, [])
  (Writer (a, w)) >>= f = let (a', w') = runWriter (f a)
                          in Writer (a', w++w')

instance Functor (Writer w)  where
  fmap = liftM

instance Applicative (Writer w) where
  pure = return
  (<*>) = ap

newtype WriterMaybe w a = WM { runWM :: (Maybe a, [w]) }

instance Monad (WriterMaybe w) where
  return x = WM (Just x, [])
  (WM (Nothing, w)) >>= f = WM (Nothing, w)
  (WM (Just x, w)) >>= f = let (x', w') = runWM (f x)
                           in WM (x', w++w')

instance Functor (WriterMaybe w)  where
  fmap = liftM

instance Applicative (WriterMaybe w) where
  pure = return
  (<*>) = ap

tellWM :: [w] -> WriterMaybe w ()
tellWM w = WM (Just (), w)

failWM :: WriterMaybe w a
failWM = WM (Nothing, [])

type Rule = String 
type Packet = String 
data Result = Accepted | Rejected deriving (Show, Eq)

filterPacket :: [Rule] -> Packet -> WriterMaybe Char Packet
filterPacket rs p = do case match rs p of
                          [] -> do tellWM ("UNMATCHED PACKET "++p)
                                   failWM
                          xs -> do mapM (\(r,res) -> do tellWM ("MATCHED " ++ p ++ " WITH RULE " ++ r)
                                                        tellWM ("RULE " ++ r ++ " " ++ show res)) xs
                                   if all (==Accepted) (map snd xs) then return p else failWM 
                       
    where
      match :: [Rule] -> Packet -> [(Rule, Result)]
      match = undefined


data T a = Uno a | Dos (a,a) | More (a,a) (T a)

instance Functor T where
  fmap f (Uno x) = Uno (f x)
  fmap f (Dos (x, y)) = Dos (f x, f y)
  fmap f (More (x, y) t) = More (f x, f y) (fmap f t)

{-

< functor.1 >
fmap id (Uno x) = Uno (id x) = Uno x = id (Uno x)
fmap id (Dos (x,y)) = Dos (id x, id y) = Dos (x,y) = id (Dos (x,y))
fmap id (More (x,y) t) = More (id x, id y) (fmap f t) ={HI}= More (x,y) t = id (More (x,y) t)

< functor.2 >
fmap f . fmap g (Uno x) = fmap f (Uno (g x)) = Uno (f.g x) = fmap (f.g) (Uno x)
fmap f . fmap g (Dos (x,y)) = fmap f (Dos (g x, g y)) = Dos (f.g x, f.g y) = fmap (f.g) (Dos (x,y)
fmap f . fmap g (More (x,y) t) = fmap f (More (g x, g y) (fmap g t)) = More (f.g x, f.g y) (fmap f. fmap g t) ={HI}=
= More (f.g x, f.g y) (fmap (f.g) t) = fmap (f.g) (More (x,y) t)

-}
data Nat = Zero | Suc Nat deriving Show
foldN Zero s z = z
foldN (Suc n) s z = s (foldN n s z)

resta :: Nat -> Nat -> Nat
resta n m = foldN m predN n
predN :: Nat -> Nat
predN Zero = Zero
predN (Suc x) = x
{-

Definimos los numero enteros de la forma (+,-) => -x === (0, x) o (y, x+y) p.a y:Nat

data Nat = Zero | Suc Nat deriving Show
foldN Zero s z = z
foldN (Suc n) s z = s (foldN n s z)

resta :: Nat -> Nat -> Nat
resta n m = foldN m predN n
    where
      predN Zero = Zero
      predN (Suc x) = x

(1)
resta = \x y. y (pred x) x
menor =\x y. isZero (resta x y)


isPos : Pair Nat Nat -> Bool
isPos = \p:Pair Nat Nat. (isZero (fst<Nat><Nat> p))

neg : Pair Nat Nat -> Pair Nat Nat
neg = \p: Pair Nat Nat. pair<Nat><Nat> (snd<Nat><Nat> p) (fst<Nat><Nat> p)

5 === (5,0)

-5 === (2, 7)
-}

{-
Nat = \forall X. (X -> X) -> X -> X
List X = \forall Y. (X -> Y -> Y) -> Y -> Y

Definir sum : List Nat -> Nat suma los elementos de la lista. Suponer que tenemos definida suma : Nat -> Nat -> Nat

-- haskell
sum xs = foldr (\y r -> y+r) 0 xs

-- lambda sin tipado
sum = \xs. xs (\y r. suma y r) zero

-- lambda tipado
zero : Nat
zero = /\X. (\s:(X -> X). \z:X. z)

sum : List Nat -> Nat
sum = \xs:List Nat.
  xs<Nat>
  (\y:Nat. \r:Nat. suma y r)
  zero

-}

{-

reverse :: [a] -> [a]
reverse [] = []
reverse (x:xs) = reverse xs ++ [x]

reverse xs = foldr (\y r -> r ++ [y]) [] xs

(++) :: [a] -> [a] -> [a]
(++) [] ys = ys
(++) (x:xs) ys = x:(append xs ys)

(++) :: [a] -> ([a] -> [a])
(++) xs ys = foldr (\y r s -> y:(r s)) id xs ys

-- lambda no tipado
(++) = \xs ys. xs (\y r s. cons y (r s)) (\x -> x) ys

reverse = \xs. xs (\y r. r ++ (cons y nil)) []

-- lambda tipado
id :: \forall X. X -> X
id = /\X. \x:X. x

(++) : \forall X. List X -> List X -> List X
(++) = /\X. \xs:List X. \ys:List X.
  xs<X -> List X>
  (\y:X. \r:X->List X. \s:List X. cons<X> y (r s))
  id<X>
  ys

reverse = \forall X. List X -> List X
reverse = /\X. \xs:List X.
  xs<List X>
  (\y:X. \r:List X. r ++ (cons<X> y nil<X>))
  nil<X>

-}
