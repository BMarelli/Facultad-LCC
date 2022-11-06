import Control.Applicative (Applicative (..))
import Control.Monad (liftM ,ap)

-- Ejercicio 2
{-

flip' :: (a, [b]) -> [(b,a)]
-- flip' (_, []) = []
-- flip' (v, x:xs) = (x,v):(flip' (v, xs))
flip' (v, xs) = foldr (\y r -> (y, v):r) [] xs

flip = \p. (snd p) (\y r. cons (pair y (fst p)) r) []

flip : \forall X. \forall Y. Pair X (List Y) -> List (Pair Y X)
flip = /\X. /\Y. \p:Pair X (List Y).
  (snd<X><List Y> p)<List (Pair Y X)>
  (\y:Y. \r:List (Pair Y X). cons<Pair Y X> (pair<Y><X> y (fst<X><List Y> p)) r)
  nil<List (Pair Y X)>

-}

-- Ejercicio 3

class Kleisli m where
  ret :: a -> m a
  (>=>) :: (a -> m b) -> (b -> m c) -> (a -> m c)

newtype State s a = St { runSt :: s -> (a,s) }

instance Kleisli (State s) where
  ret x = St (\s -> (x,s))
  f >=> g = \x -> St (\s -> let (x', s') = runSt (f x) s
                             in runSt (g x') s')

instance Monad m => Kleisli m where
  ret x = return x
  f >=> g = \x -> f x >>= g
