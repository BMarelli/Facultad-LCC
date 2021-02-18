module Eval2
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

-- Mónada estado, con manejo de errores
newtype StateError a =
  StateError { runStateError :: Env -> Either Error (Pair a Env) }


-- Para calmar al GHC
instance Functor StateError where
  fmap = liftM

instance Applicative StateError where
  pure  = return
  (<*>) = ap

-- Ejercicio 2.a: Dar una instancia de Monad para StateError:
instance Monad StateError where
  return x = StateError (\s -> Right (x :!: s))
  m >>= f = StateError (\s -> runStateError m s >>= \(v :!: s') -> runStateError (f v) s')

-- Ejercicio 2.b: Dar una instancia de MonadError para StateError:
instance MonadError StateError where
  throw e = StateError (\_ -> Left e)

-- Ejercicio 2.c: Dar una instancia de MonadState para StateError:
instance MonadState StateError where
  lookfor v = StateError $ \s -> case lookfor' v s of
                                    Just v' -> Right (v' :!: s)
                                    Nothing -> Left UndefVar
      where lookfor'= M.lookup
  update v i = StateError (\s -> Right (() :!: update' v i s)) where update' = M.insert

-- Ejercicio 2.d: Implementar el evaluador utilizando la monada StateError.
-- Evalua un programa en el estado nulo
eval :: Comm -> Either Error Env
eval p = runStateError (stepCommStar p) initEnv >>= \(() :!: s) -> return s

-- Evalua multiples pasos de un comando, hasta alcanzar un Skip
stepCommStar :: (MonadState m, MonadError m) => Comm -> m ()
stepCommStar Skip = return ()
stepCommStar c    = stepComm c >>= \c' -> stepCommStar c'

-- Evalua un paso de un comando
stepComm :: (MonadState m, MonadError m) => Comm -> m Comm
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
evalExp :: (MonadState m, MonadError m) => Exp a -> m a
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
                             if exp2' == 0 then throw DivByZero
                             else return (div exp1' exp2')
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
