module ArrSeq where

import Seq
import Par
import qualified Arr as A
import  Arr ((!))

instance Seq A.Arr where
  emptyS = A.empty
  singletonS = singletonS_
  lengthS = A.length
  nthS = (!)
  tabulateS = A.tabulate
  mapS = mapS_
  filterS = filterS_
  appendS = appendS_
  takeS = takeS_
  dropS = dropS_
  showtS = showtS_
  showlS = showlS_
  joinS = A.flatten
  reduceS = reduceS_
  scanS = scanS_
  fromList = A.fromList


singletonS_ x = fromList [x]

mapS_ f xs = tabulateS (\i -> (f (nthS xs i))) (lengthS xs)

-- filterS_ p xs | len == 0     = emptyS
--               | len == 1     = if p (nthS xs 0) then xs else emptyS
--               | otherwise    = let 
--                                   m = (div len 2)
--                                   (ys, zs) = filterS_ p (takeS_ xs m) ||| filterS_ p (dropS_ xs m)
--                                in appendS_ ys zs
--     where len = lengthS xs

filterS_ p xs = joinS (mapS_ (\x -> if p x then (singletonS_ x) else emptyS) xs)

appendS_ xs ys = tabulateS f (n + m)
    where 
      n = lengthS xs
      m = lengthS ys
      f i | i < n      = nthS xs i
          | otherwise  = nthS ys (i - n)

takeS_ xs n | len < n         = xs
            | otherwise       = A.subArray 0 n xs
    where len = lengthS xs

dropS_ xs n | len < n         = emptyS
            | otherwise       = A.subArray n (len - n) xs
    where len = lengthS xs

showtS_ xs | len == 0       = EMPTY
           | len == 1       = ELT (nthS xs 0)
           | otherwise      = let
                                 m = (div len 2)
                                 (l,r) = (takeS_ xs m) ||| (dropS_ xs m)
                              in NODE l r
    where len = lengthS xs

showlS_ xs | len == 0       = NIL
           | otherwise      = CONS (nthS xs 0)  (dropS_ xs 1)
    where len = lengthS xs

contract :: (a -> a -> a) -> A.Arr a -> A.Arr a
contract f xs = if even len then tabulateS f' m
                else tabulateS f' (m + 1)
    where
      len = lengthS xs
      m = div len 2
      f' i = if (2 * i) == (len - 1) then (nthS xs (len - 1)) 
             else f (nthS xs (2 * i)) (nthS xs (2 * i + 1))

reduceS_ f e xs | len == 0      = e
                | len == 1      = f e (nthS xs 0)
                | otherwise     = let ctr = contract f xs
                                      ys = reduceS_ f e ctr
                                  in id ys
    where len = lengthS xs

scanS_ f e xs | len == 0        = (emptyS, e)
              | len == 1        = (singletonS_ e, f e (nthS xs 0))
              | otherwise       = let ctr = contract f xs
                                      (ys, y) = scanS_ f e ctr
                                  in (buildList f xs ys, y)
    where
      len = lengthS xs
      buildList f xs ys = tabulateS (\i -> if even i then (nthS ys (div i 2))
                                           else f (nthS ys (div i 2)) (nthS xs (i - 1)))
                                    len
