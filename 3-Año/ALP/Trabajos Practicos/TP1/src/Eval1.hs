module Eval1
  ( eval
  , State
  )
where

import           AST
import qualified Data.Map.Strict               as M
import           Data.Strict.Tuple

-- Estados
type State = M.Map Variable Int

-- Estado nulo
-- Completar la definición
initState :: State
initState = M.empty

-- Busca el valor de una variable en un estado
-- Completar la definición
lookfor :: Variable -> State -> Int
lookfor k s = s M.! k

-- Cambia el valor de una variable en un estado
-- Completar la definición
update :: Variable -> Int -> State -> State
update = M.insert

-- Evalua un programa en el estado nulo
eval :: Comm -> State
eval p = stepCommStar p initState

-- Evalua multiples pasos de un comnado en un estado,
-- hasta alcanzar un Skip
stepCommStar :: Comm -> State -> State
stepCommStar Skip s = s
stepCommStar c    s = Data.Strict.Tuple.uncurry stepCommStar $ stepComm c s

-- Evalua un paso de un comando en un estado dado
-- Completar la definición
stepComm :: Comm -> State -> Pair Comm State
stepComm (Let v exp) s = let (exp' :!: s') = evalExp exp s
                             s'' = update v exp' s'
                         in Skip :!: s''
stepComm (Seq Skip com) s = com :!: s
stepComm (Seq com com') s = let (com'' :!: s') = stepComm com s
                            in (Seq com'' com') :!: s'
stepComm (IfThenElse b com com') s = let (bool :!: s') = evalExp b s
                                     in (case bool of
                                            True -> com :!: s'
                                            False -> com' :!: s')

stepComm (While b com) s = let (bool :!: s') = evalExp b s
                           in (case bool of
                                  True -> Seq com (While b com) :!: s'
                                  False -> Skip :!: s')
-- Evalua una expresion
-- Completar la definición
evalExp :: Exp a -> State -> Pair a State
evalExp (Const v) s = v :!: s
evalExp (Var xs) s = lookfor xs s :!: s
evalExp (EAssgn xs exp) s = let (n :!: s') = evalExp exp s
                                s'' = update xs n s'
                            in n :!: s''  
evalExp (ESeq exp exp') s = let (_ :!: s') = evalExp exp s
                                (n' :!: s'') = evalExp exp' s'
                            in n' :!: s''
evalExp (UMinus exp) s = let (n :!: s') = evalExp exp s
                         in -n :!: s'
evalExp BTrue s = True :!: s
evalExp BFalse s = False :!: s
evalExp (Not exp) s = let (n :!: s') = evalExp exp s
                      in (not n) :!: s'
evalExp (Plus exp exp') s = let (n :!: s') = evalExp exp s
                                (n' :!: s'') = evalExp exp' s'
                            in (n + n') :!: s''
evalExp (Minus exp exp') s = let (n :!: s') = evalExp exp s
                                 (n' :!: s'') = evalExp exp' s'
                            in (n - n') :!: s''
evalExp (Times exp exp') s = let (n :!: s') = evalExp exp s
                                 (n' :!: s'') = evalExp exp' s'
                            in (n * n') :!: s''
evalExp (Div exp exp') s = let (n :!: s') = evalExp exp s
                               (n' :!: s'') = evalExp exp' s'
                            in (div n n') :!: s''
evalExp (Eq exp exp') s = let (n :!: s') = evalExp exp s
                              (n' :!: s'') = evalExp exp' s'
                            in (n == n') :!: s''
evalExp (NEq exp exp') s = let (n :!: s') = evalExp exp s
                               (n' :!: s'') = evalExp exp' s'
                            in (n /= n') :!: s''
evalExp (Lt exp exp') s = let (n :!: s') = evalExp exp s
                              (n' :!: s'') = evalExp exp' s'
                            in (n < n') :!: s''
evalExp (Gt exp exp') s = let (n :!: s') = evalExp exp s
                              (n' :!: s'') = evalExp exp' s'
                            in (n > n') :!: s''
evalExp (Or exp exp') s = let (n :!: s') = evalExp exp s
                              (n' :!: s'') = evalExp exp' s'
                            in (n || n') :!: s''
evalExp (And exp exp') s = let (n :!: s') = evalExp exp s
                               (n' :!: s'') = evalExp exp' s'
                            in (n && n') :!: s''
