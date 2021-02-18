module Eval3
  ( eval
  , Env
  )
where

import           AST
import           Monads
import qualified Data.Map.Strict               as M
import           Data.Maybe
import           Data.Strict.Tuple
import           Control.Monad                  ( liftM
                                                , ap
                                                )

-- Entornos
type Env = M.Map Variable Int

-- Entorno nulo
initEnv :: Env
initEnv = M.empty

-- Ejercicio 3.a: Proponer una nueva monada que lleve el costo de las 
-- operaciones efectuadas en la computacion, ademas de manejar errores y 
-- estado, y de su instancia de mónada. Llamela StateErrorCost.
newtype StateErrorCost a = StateErrorCost {runStateErrorCost :: Env -> Either Error (Pair a Env, Cost)}

-- Recuerde agregar las siguientes instancias para calmar al GHC:
instance Functor StateErrorCost where
  fmap = liftM

instance Applicative StateErrorCost where
  pure  = return
  (<*>) = ap

instance Monad StateErrorCost where
  return x = StateErrorCost (\s -> Right (x :!: s, 0))
  m >>= f = StateErrorCost (\s -> do (v :!: s', x) <- runStateErrorCost m s
                                     (v' :!: s'', x') <- runStateErrorCost (f v) s'
                                     return (v' :!: s'', x + x'))

-- Ejercicio 3.c: Dar una instancia de MonadCost para StateErrorCost.
instance MonadCost StateErrorCost where
  increase x = StateErrorCost (\s -> Right (() :!: s, x))

-- Ejercicio 3.d: Dar una instancia de MonadError para StateErrorCost.
instance MonadError StateErrorCost where
  throw e = StateErrorCost (\_ -> Left e)

-- Ejercicio 3.e: Dar una instancia de MonadState para StateErrorCost.
instance MonadState StateErrorCost where
  lookfor v = StateErrorCost $ \s -> case lookfor' v s of
                                        Just v' -> Right (v' :!: s, 0)
                                        Nothing -> Left UndefVar
      where lookfor' = M.lookup
  update v i = StateErrorCost (\s -> Right (() :!: update' v i s, 0)) where update' = M.insert

-- Ejercicio 3.f: Implementar el evaluador utilizando la monada StateErrorCost.
-- Evalua un programa en el estado nulo
eval :: Comm -> Either Error (Env, Cost)
eval p = runStateErrorCost (stepCommStar p) initEnv >>= \(() :!: s, x) -> return (s, x)

-- Evalua multiples pasos de un comando, hasta alcanzar un Skip
stepCommStar :: (MonadState m, MonadError m, MonadCost m) => Comm -> m ()
stepCommStar Skip = return ()
stepCommStar c    = stepComm c >>= \c' -> stepCommStar c'

-- Evalua un paso de un comando
stepComm :: (MonadState m, MonadError m, MonadCost m) => Comm -> m Comm
stepComm Skip = return Skip
stepComm (Let x exp) = do exp' <- evalIntExp exp
                          update x exp'
                          return Skip
stepComm (Seq Skip com2) = stepComm com2
stepComm (Seq com1 com2) = do com1' <- stepComm com1
                              return (Seq com1' com2)
stepComm (IfThenElse exp com1 com2) = do b <- evalIntExp exp
                                         if b then return com1
                                         else return com2
stepComm c@(While exp com) = do b <- evalIntExp exp
                                if b then return (Seq com c)
                                else return Skip

-- Evalua una expresion 
evalIntExp :: (MonadState m, MonadError m, MonadCost m) => Exp a -> m a
evalIntExp (Const n) = return n
evalIntExp (Var x) = lookfor x
evalIntExp (UMinus exp) = do exp' <- evalIntExp exp
                             increase 1
                             return $ -exp'
evalIntExp (Plus exp1 exp2) = do exp1' <- evalIntExp exp1
                                 exp2' <- evalIntExp exp2
                                 increase 1
                                 return $ exp1' + exp2'
evalIntExp (Minus exp1 exp2) = do exp1' <- evalIntExp exp1
                                  exp2' <- evalIntExp exp2
                                  increase 1
                                  return $ exp1' - exp2'
evalIntExp (Times exp1 exp2) = do exp1' <- evalIntExp exp1
                                  exp2' <- evalIntExp exp2
                                  increase 2
                                  return $ exp1' * exp2'
evalIntExp (Div exp1 exp2) = do exp1' <- evalIntExp exp1
                                exp2' <- evalIntExp exp2
                                increase 2
                                if exp2' == 0 then throw DivByZero
                                else return (div exp1' exp2')
evalIntExp BTrue = return True
evalIntExp BFalse = return False
evalIntExp (Lt exp1 exp2) = do exp1' <- evalIntExp exp1
                               exp2' <- evalIntExp exp2
                               increase 1
                               return $ exp1' < exp2'
evalIntExp (Gt exp1 exp2) = do exp1' <- evalIntExp exp1
                               exp2' <- evalIntExp exp2
                               increase 1
                               return $ exp1' > exp2'
evalIntExp (And exp1 exp2) = do exp1' <- evalIntExp exp1
                                exp2' <- evalIntExp exp2
                                increase 1
                                return $ exp1' && exp2'
evalIntExp (Or exp1 exp2) = do exp1' <- evalIntExp exp1
                               exp2' <- evalIntExp exp2
                               increase 1
                               return $ exp1' || exp2'
evalIntExp (Not exp) = do exp' <- evalIntExp exp
                          increase 1
                          return $ not exp'
evalIntExp (Eq exp1 exp2) = do exp1' <- evalIntExp exp1
                               exp2' <- evalIntExp exp2
                               increase 1
                               return $ exp1' == exp2'
evalIntExp (NEq exp1 exp2) = do exp1' <- evalIntExp exp1
                                exp2' <- evalIntExp exp2
                                increase 1
                                return $ exp1' /= exp2'
evalIntExp (EAssgn x exp) = do exp' <- evalIntExp exp
                               update x exp'
                               return exp'
evalIntExp (ESeq exp1 exp2) = do evalIntExp exp1
                                 evalIntExp exp2
