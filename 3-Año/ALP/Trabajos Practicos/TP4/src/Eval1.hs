module Eval1
  ( eval
  , Env
  )
where

import           AST
import           Monads
import qualified Data.Map.Strict               as M
import           Data.Maybe
import           Prelude                 hiding ( fst
                                                , snd
                                                )
import           Data.Strict.Tuple
import           Control.Monad                  ( liftM
                                                , ap
                                                )

-- Entornos
type Env = M.Map Variable Int

-- Entorno nulo
initEnv :: Env
initEnv = M.empty

-- Mónada estado
newtype State a = State { runState :: Env -> Pair a Env }

instance Monad State where
  return x = State (\s -> (x :!: s))
  m >>= f = State (\s -> let (v :!: s') = runState m s in runState (f v) s')

-- Para calmar al GHC
instance Functor State where
  fmap = liftM

instance Applicative State where
  pure  = return
  (<*>) = ap

instance MonadState State where
  lookfor v = State (\s -> (lookfor' v s :!: s))
    where lookfor' v s = fromJust $ M.lookup v s
  update v i = State (\s -> (() :!: update' v i s)) where update' = M.insert

-- Ejercicio 1.b: Implementar el evaluador utilizando la monada State

-- Evalua un programa en el estado nulo
eval :: Comm -> Env
eval p = snd (runState (stepCommStar p) initEnv)

-- Evalua multiples pasos de un comando, hasta alcanzar un Skip
stepCommStar :: MonadState m => Comm -> m ()
stepCommStar Skip = return ()
stepCommStar c    = stepComm c >>= \c' -> stepCommStar c'

-- Evalua un paso de un comando
stepComm :: MonadState m => Comm -> m Comm
stepComm Skip = return Skip
stepComm (Let x exp) = do exp' <- evalExp exp
                          update x exp'
                          return Skip
stepComm (Seq Skip com2) = stepComm com2
stepComm (Seq com1 com2) = do com1' <- stepComm com1
                              return (Seq com1' com2)
stepComm (IfThenElse exp com1 com2) = do b <- evalExp exp
                                         if b then return com1
                                         else return com2
stepComm c@(While exp com) = do b <- evalExp exp
                                if b then return (Seq com c)
                                else return Skip

-- Evalua una expresion
evalExp :: MonadState m => Exp a -> m a
evalExp (Const n) = return n
evalExp (Var x) = lookfor x
evalExp (UMinus exp) = do exp' <- evalExp exp
                          return $ -exp'
evalExp (Plus exp1 exp2) = do exp1' <- evalExp exp1
                              exp2' <- evalExp exp2
                              return $ exp1' + exp2'
evalExp (Minus exp1 exp2) = do exp1' <- evalExp exp1
                               exp2' <- evalExp exp2
                               return $ exp1' - exp2'
evalExp (Times exp1 exp2) = do exp1' <- evalExp exp1
                               exp2' <- evalExp exp2
                               return $ exp1' * exp2'
evalExp (Div exp1 exp2) = do exp1' <- evalExp exp1
                             exp2' <- evalExp exp2
                             return $ div exp1' exp2'
evalExp BTrue = return True
evalExp BFalse = return False
evalExp (Lt exp1 exp2) = do exp1' <- evalExp exp1
                            exp2' <- evalExp exp2
                            return $ exp1' < exp2'
evalExp (Gt exp1 exp2) = do exp1' <- evalExp exp1
                            exp2' <- evalExp exp2
                            return $ exp1' > exp2'
evalExp (And exp1 exp2) = do exp1' <- evalExp exp1
                             exp2' <- evalExp exp2
                             return $ exp1' && exp2'
evalExp (Or exp1 exp2) = do exp1' <- evalExp exp1
                            exp2' <- evalExp exp2
                            return $ exp1' || exp2'
evalExp (Not exp) = do exp' <- evalExp exp
                       return $ not exp'
evalExp (Eq exp1 exp2) = do exp1' <- evalExp exp1
                            exp2' <- evalExp exp2
                            return $ exp1' == exp2'
evalExp (NEq exp1 exp2) = do exp1' <- evalExp exp1
                             exp2' <- evalExp exp2
                             return $ exp1' /= exp2'
evalExp (EAssgn x exp) = do exp' <- evalExp exp
                            update x exp'
                            return exp'
evalExp (ESeq exp1 exp2) = do evalExp exp1
                              evalExp exp2
