module Eval2
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
lookfor :: Variable -> State -> Either Error Int
lookfor k s = case s M.!? k of
                  Nothing -> Left UndefVar
                  Just v -> Right v

-- Cambia el valor de una variable en un estado
-- Completar la definición
update :: Variable -> Int -> State -> State
update = M.insert 

-- Evalua un programa en el estado nulo
eval :: Comm -> Either Error State
eval p = stepCommStar p initState

-- Evalua multiples pasos de un comnado en un estado,
-- hasta alcanzar un Skip
stepCommStar :: Comm -> State -> Either Error State
stepCommStar Skip s = return s
stepCommStar c    s = do
  (c' :!: s') <- stepComm c s
  stepCommStar c' s'

-- Evalua un paso de un comando en un estado dado
-- Completar la definición
stepComm :: Comm -> State -> Either Error (Pair Comm State)
-- stepComm = undefined
stepComm (Let v exp) s = case evalExp exp s of
                            Right (exp' :!: s') -> let s'' = update v exp' s'
                                             in Right (Skip :!: s'') 
                            Left error -> Left error
stepComm (Seq Skip com) s = Right (com :!: s)
stepComm (Seq com com') s = case stepComm com s of
                                  Right (com'' :!: s') -> Right ((Seq com'' com') :!: s')
                                  Left error -> Left error
stepComm (IfThenElse b com com') s = case evalExp b s of 
                                          Right (True :!: s') -> Right (com :!: s')
                                          Right (False :!: s') -> Right (com' :!: s')
                                          Left error -> Left error
                                          
stepComm (While b com) s = case evalExp b s of
                              Right (True :!: s') -> Right (Seq com (While b com) :!: s')
                              Right (False :!: s') -> Right (Skip :!: s')
                              Left error -> Left error

-- Evalua una expresion
-- Completar la definición
evalExp :: Exp a -> State -> Either Error (Pair a State)
evalExp (Const v) s = Right (v :!: s)
evalExp (Var xs) s = case lookfor xs s of
                            Right v -> Right (v :!: s)
                            Left error -> Left error
evalExp (UMinus exp) s = case evalExp exp s of
                              Right (n :!: s') -> Right (-n :!: s')
                              Left error -> Left error

evalExp (EAssgn xs exp) s = case evalExp exp s of
                                 Right (n :!: s') -> Right (n :!: update xs n s')
                                 Left error -> Left error
evalExp (ESeq exp exp') s = case evalExp exp s of
                                  Right (_ :!: s') -> case evalExp exp' s' of
                                                        Right (n' :!: s'') -> Right (n' :!: s'')
                                                        Left error -> Left error
                                  Left error -> Left error
evalExp BTrue s = Right(True :!: s)
evalExp BFalse s = Right (False :!: s)
evalExp (Not exp) s = case evalExp exp s of
                           Right (n :!: s') -> Right ((not n) :!: s')
                           Left error -> Left error
evalExp (Plus exp exp') s = case evalExp exp s of
                                Right (n :!: s') -> case evalExp exp' s' of
                                                      Right (n' :!: s'') -> Right((n + n') :!: s'')
                                                      Left error -> Left error
                                Left error -> Left error
evalExp (Minus exp exp') s = case evalExp exp s of
                                Right (n :!: s') -> case evalExp exp' s' of
                                                      Right (n' :!: s'') -> Right((n - n') :!: s'')
                                                      Left error -> Left error
                                Left error -> Left error
evalExp (Times exp exp') s = case evalExp exp s of
                                Right (n :!: s') -> case evalExp exp' s' of
                                                      Right (n' :!: s'') -> Right((n * n') :!: s'')
                                                      Left error -> Left error
                                Left error -> Left error
evalExp (Div exp exp') s = case evalExp exp s of
                                Right (n :!: s') -> case evalExp exp' s' of
                                                      Right (n' :!: s'') -> if n' == 0 then Left DivByZero 
                                                                            else Right((div n n') :!: s'')
                                                      Left error -> Left error
                                Left error -> Left error
evalExp (Eq exp exp') s = case evalExp exp s of
                                Right (n :!: s') -> case evalExp exp' s' of
                                                      Right (n' :!: s'') -> Right((n == n') :!: s'')
                                                      Left error -> Left error
                                Left error -> Left error
evalExp (NEq exp exp') s = case evalExp exp s of
                                Right (n :!: s') -> case evalExp exp' s' of
                                                      Right (n' :!: s'') -> Right((n /= n') :!: s'')
                                                      Left error -> Left error
                                Left error -> Left error
evalExp (Lt exp exp') s = case evalExp exp s of
                                Right (n :!: s') -> case evalExp exp' s' of
                                                      Right (n' :!: s'') -> Right((n < n') :!: s'')
                                                      Left error -> Left error
                                Left error -> Left error
evalExp (Gt exp exp') s = case evalExp exp s of
                                Right (n :!: s') -> case evalExp exp' s' of
                                                      Right (n' :!: s'') -> Right((n > n') :!: s'')
                                                      Left error -> Left error
                                Left error -> Left error
evalExp (Or exp exp') s = case evalExp exp s of
                                Right (n :!: s') -> case evalExp exp' s' of
                                                      Right (n' :!: s'') -> Right((n || n') :!: s'')
                                                      Left error -> Left error
                                Left error -> Left error
evalExp (And exp exp') s = case evalExp exp s of
                                Right (n :!: s') -> case evalExp exp' s' of
                                                      Right (n' :!: s'') -> Right((n && n') :!: s'')
                                                      Left error -> Left error
                                Left error -> Left error
