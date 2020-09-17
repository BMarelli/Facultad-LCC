import Seq
import Par
import ArrSeq
import qualified Arr as A

s = (fromList [(0,5), (1,2), (3,5)] :: A.Arr (Int, Int))

-- Ejercicio 2
count :: Seq s => s (Int, Int) -> Int
count xs = let
              ys = tabulateS (\i -> let x = (nthS xs i) in (0, fst x, snd x)) (lengthS xs)
              (zs, z) = scanS in_ (nthS ys 0) (ys :: A.Arr (Int, Int, Int))
              ws = appendS (dropS zs 1) (singletonS z)
           in (fst_ (reduceS sum_ (0,0,0) ws)) - 1
    where
      fst_ :: (a ,a ,a) -> a
      fst_ (x, _, _) = x
      sum_ :: (Int, Int, Int) -> (Int, Int, Int) -> (Int, Int, Int)
      sum_ (i, _, _) (i', _, _) = (i + i', 0, 0)
      in_ :: (Int, Int, Int) -> (Int, Int, Int) -> (Int, Int, Int)
      in_ (i, x, y) (i', w, z) = if z < y && x < w then (i + 1, x, y)
                        else (i', w, z)

-- count :: Seq s => s (Int, Int) -> Int
-- count xs = let
--               ys = mapS (\(_, y) -> (0,y)) xs
--               (zs, z) = scanS in_ (nthS ys 0) ys
--               ws = appendS (dropS zs 1) (singletonS z)
--            in (fst (reduceS sum_ (0,0) ws)) - 1
--     where
--       sum_ (i, _) (i', _) = (i + i', 0)
--       in_ (i, x) (i', y) = if y < x then (i + 1, x) else (i', y)
