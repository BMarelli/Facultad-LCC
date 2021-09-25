import Control.Applicative (Applicative (..))
import Control.Monad (liftM ,ap)

data Type a = TVar a
            | TInt
            | Fun (Type a) (Type a)
            deriving Show

instance Monad Type where
  return x = TVar x
  TInt >>= _ = TInt
  (TVar v) >>= f = f v
  (Fun t1 t2) >>= f = do t1' <- t1
                         t2' <- t2
                         Fun (f t1') (f t2')

instance Functor Type  where
  fmap = liftM

instance Applicative Type where
  pure = return 
  (<*>) = ap

apply :: (a -> Type b) -> Type a -> Type b
apply f t = do t' <- t
               f t'

comp :: (a -> Type b) -> (c -> Type a) -> (c -> Type b)
comp f g = \c -> do a <- g c
                    f a

{-
isNil :: [a] -> Bool
isNil [] = True
isNil xs = False

isNil xs = foldr (\y r -> False) True

-- Sin Tipado
true = \t f. t
false = \t f. f

isNil = \xs . xs (\y r . false) true

-- Tipado
Bool : \forall X. X -> X -> X
true : Bool
true = /\X. \t:X. \f:X. t
false : Bool
false = /\X. \t:X. \f:X. f

List X = \forall Y. (X -> Y -> Y) -> Y

isNil = /\X. \xs:List X. xs<Bool> (\y:X. \r:Bool. false) true 


tail :: [a] -> [a]
tail xs = fst (tail' xs ([],[]))
    where
      tail' xs e = foldr (\y r -> (snd r, y:(snd r))) e xs

-- tail lambda no tipado
zz = pair nil nil
tail = \xs . fst (tail' xs zz)
tail' = \xs e . xs (\y r . (snd r, y:(snd r))) e

-- tail lambda tipado
zz : \forall X. Pair (List X) (List X)
zz = /\X. pair<List X><List X> (nil<X>) (nil<X>)
tail : \forall X . List X -> List X
tail = /\X. \xs:List X. fst<List X> (tail'<X> xs zz)
tail' : \forall X. List X -> Pair (List X) (List X) -> Pair (List X) (List X)
tail' = /\X. \xs:List X. \zz:Pair (List X) (List X).
         xs<Pair (List X) (List X)>
         (\y:X. \r:Pair (List X) (List X). pair<List X><List X> (snd<List X><List X> r) (cons<X> y (snd<List X><List X> r)))
         zz<X>
-}


{-

List X = \forall Y. (X -> Y -> Y) -> Y
Pair X Y = \forall Z. (X -> Y -> Z) -> Z

listPair :: (a, [b]) -> [(a,b)]
listPair (_, []) = []
listPair (v, x:xs) = (v,x):(listPair (v,xs))

listPair (v,xs) = foldr (\y r -> (v,y):r) [] xs

listPair : \forall X. \forall Y. Pair X (List Y) -> List (X, Y)
listPair = /\X. /\Y. \p:Pair X (List Y).
    (snd<X><List Y> p)<List (Pair X Y)>
      (\y:Y. \r:List (Pair X Y). cons<List (Pair X Y)> (pair<X><Y> (fst<X> p) y) r))
      nil<List (Pair X Y)>

-}
