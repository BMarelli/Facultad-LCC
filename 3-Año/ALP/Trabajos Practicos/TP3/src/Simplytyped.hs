module Simplytyped
  ( conversion
  ,    -- conversion a terminos localmente sin nombre
    eval
  ,          -- evaluador
    infer
  ,         -- inferidor de tipos
    quote          -- valores -> terminos
  )
where

import           Data.List
import           Data.Maybe
import           Prelude                 hiding ( (>>=) )
import           Text.PrettyPrint.HughesPJ      ( render )
import           PrettyPrinter
import           Common

-- conversion a términos localmente sin nombres
conversion :: LamTerm -> Term
conversion = conversion' []

conversion' :: [String] -> LamTerm -> Term
conversion' b (LVar n    ) = maybe (Free (Global n)) Bound (n `elemIndex` b)
conversion' b (LApp t u  ) = conversion' b t :@: conversion' b u
conversion' b (LAbs n t u) = Lam t (conversion' (n : b) u)
conversion' b (LLet x u v) = Let (conversion' b u) (conversion' (x : b) v)
conversion' b (LAs u t)    = As (conversion' b u) t
conversion' _ LUnit        = Unit
conversion' b (LFst u)     = Fst (conversion' b u)
conversion' b (LSnd u)     = Snd (conversion' b u)
conversion' b (LPair u v)  = Pair (conversion' b u) (conversion' b v)
conversion' _ LZero        = Zero
conversion' b (LSuc u)     = Suc (conversion' b u)
conversion' b (LRec u v w) = Rec (conversion' b u) (conversion' b v) (conversion' b w)

-----------------------
--- eval
-----------------------

sub :: Int -> Term -> Term -> Term
sub i t (Bound j) | i == j    = t
sub _ _ (Bound j) | otherwise = Bound j
sub _ _ (Free n)              = Free n
sub i t (u :@: v)             = sub i t u :@: sub i t v
sub i t (Lam t' u)            = Lam t' (sub (i + 1) t u)
sub i t (Let u v)             = Let v (sub (i + 1) t u)
sub i t (As u t')             = As (sub (i+1) t u) t'
sub _ _ Unit                  = Unit
sub i t (Fst u)               = Fst (sub i t u)
sub i t (Snd u)               = Snd (sub i t u)
sub i t (Pair u v)            = Pair (sub i t u) (sub i t v)
sub _ _ Zero                  = Zero
sub i t (Suc u)               = Suc (sub i t u)
sub i t (Rec u v w)           = Rec (sub i t u) (sub i t v) (sub i t w)

-- evaluador de términos
eval :: NameEnv Value Type -> Term -> Value
eval _ (Bound _             ) = error "variable ligada inesperada en eval"
eval e (Free  n             ) = fst $ fromJust $ lookup n e
eval _ (Lam      t   u      ) = VLam t u
eval e (Lam _ u  :@: Lam s v) = eval e (sub 0 (Lam s v) u)
eval e (Lam _ u1 :@: u2     ) = let v2 = eval e u2 in eval e (sub 0 (quote v2) u1)
eval e (    u    :@:   v    ) = case eval e u of
                                  VLam t u' -> eval e (Lam t u' :@: v)
                                  _         -> error "Error de tipo en run-time, verificar type checker"
eval e (Let      u   v      ) = let u2 = eval e u in eval e (sub 0 (quote u2) v)
eval e (As       u   _      ) = eval e u
eval _ Unit                   = VUnit
eval e (Fst u)                = case eval e u of
                                  VPair v _ -> v
                                  _         -> error "Error de tipo en run-time, verificar type checker"
eval e (Snd u)                = case eval e u of
                                  VPair _ v -> v
                                  _         -> error "Error de tipo en run-time, verificar type checker"
eval e (Pair u v)             = VPair (eval e u) (eval e v)
eval _ Zero                   = VNum NZero
eval e (Suc u)                = case eval e u of
                                  VNum v -> VNum (NSuc v)
                                  _      -> error "Error de tipo en run-time, verificar type checker"
eval e (Rec u _ Zero)         = eval e u
eval e (Rec u v (Suc w))      = eval e $ (v :@: Rec u v w) :@: w
eval e (Rec u v w)            = let w' = eval e w in eval e $ Rec u v (quote w')

-----------------------
--- quoting
-----------------------

quote :: Value -> Term
quote (VLam t f)      = Lam t f
quote VUnit           = Unit
quote (VPair u v)     = Pair (quote u) (quote v)
quote (VNum NZero)    = Zero
quote (VNum (NSuc u)) = Suc (quote (VNum u))

----------------------
--- type checker
-----------------------

-- type checker
infer :: NameEnv Value Type -> Term -> Either String Type
infer = infer' []

-- definiciones auxiliares
ret :: Type -> Either String Type
ret = Right

err :: String -> Either String Type
err = Left

(>>=) :: Either String Type -> (Type -> Either String Type) -> Either String Type
(>>=) v f = either Left f v
-- fcs. de error

matchError :: Type -> Type -> Either String Type
matchError t1 t2 =
  err
    $  "se esperaba "
    ++ render (printType t1)
    ++ ", pero "
    ++ render (printType t2)
    ++ " fue inferido."

notfunError :: Type -> Either String Type
notfunError t1 = err $ render (printType t1) ++ " no puede ser aplicado."

notfoundError :: Name -> Either String Type
notfoundError n = err $ show n ++ " no está definida."

infer' :: Context -> NameEnv Value Type -> Term -> Either String Type
infer' c _ (Bound i)   = ret (c !! i)
infer' _ e (Free  n)   = case lookup n e of
  Nothing     -> notfoundError n
  Just (_, t) -> ret t
infer' c e (t :@: u)   = infer' c e t >>= \tt -> infer' c e u >>= \tu ->
  case tt of
    FunT t1 t2 -> if tu == t1 then ret t2 else matchError t1 tu
    _          -> notfunError tt
infer' c e (Lam t u)   = infer' (t : c) e u >>= \tu -> ret $ FunT t tu
infer' c e (Let u v)   = infer' c e u >>= \tu -> infer' (tu : c) e v
infer' c e (As u t )   = infer' c e u >>= \tu -> if t == tu then ret t else matchError t tu
infer' _ _ Unit        = ret UnitT
infer' c e (Fst u)     = infer' c e u >>= \tu -> case tu of
                           PairT t1 _ -> ret t1
                           _          -> err "fst espera un tipo pair."
infer' c e (Snd u)     = infer' c e u >>= \tu -> case tu of
                           PairT _ t2 -> ret t2
                           _          -> err "snd espera un tipo pair."
infer' c e (Pair u v)  = infer' c e u >>= \tu -> infer' c e v >>= \tv -> ret $ PairT tu tv
infer' _ _ Zero        = ret NatT
infer' c e (Suc u)     = infer' c e u >>= \tu -> case tu of
                           NatT -> ret tu
                           _    -> matchError NatT tu
infer' c e (Rec u v w) = infer' c e u >>= \tu -> infer' c e v >>= \tv ->
                           if tv == FunT tu (FunT NatT tu) then infer' c e w >>= \tw -> if tw == NatT then ret tu
                                                                                        else matchError NatT tw
                           else matchError (FunT tu (FunT NatT tu)) tv

----------------------------------
