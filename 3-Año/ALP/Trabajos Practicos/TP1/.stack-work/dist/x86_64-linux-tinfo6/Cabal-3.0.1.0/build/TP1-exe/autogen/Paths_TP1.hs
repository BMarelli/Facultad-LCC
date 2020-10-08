{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_TP1 (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/mnt/c/Users/Bautista Marelli/Documents/Facultad/ALP/TrbajosPracticos/TP1/.stack-work/install/x86_64-linux-tinfo6/b1b95b3b867481dc84643790cb588e9700dac16f35fb0898f8cdac4c733e2611/8.8.3/bin"
libdir     = "/mnt/c/Users/Bautista Marelli/Documents/Facultad/ALP/TrbajosPracticos/TP1/.stack-work/install/x86_64-linux-tinfo6/b1b95b3b867481dc84643790cb588e9700dac16f35fb0898f8cdac4c733e2611/8.8.3/lib/x86_64-linux-ghc-8.8.3/TP1-0.1.0.0-CcRaqoovTxfGhPFm8p8E2Q-TP1-exe"
dynlibdir  = "/mnt/c/Users/Bautista Marelli/Documents/Facultad/ALP/TrbajosPracticos/TP1/.stack-work/install/x86_64-linux-tinfo6/b1b95b3b867481dc84643790cb588e9700dac16f35fb0898f8cdac4c733e2611/8.8.3/lib/x86_64-linux-ghc-8.8.3"
datadir    = "/mnt/c/Users/Bautista Marelli/Documents/Facultad/ALP/TrbajosPracticos/TP1/.stack-work/install/x86_64-linux-tinfo6/b1b95b3b867481dc84643790cb588e9700dac16f35fb0898f8cdac4c733e2611/8.8.3/share/x86_64-linux-ghc-8.8.3/TP1-0.1.0.0"
libexecdir = "/mnt/c/Users/Bautista Marelli/Documents/Facultad/ALP/TrbajosPracticos/TP1/.stack-work/install/x86_64-linux-tinfo6/b1b95b3b867481dc84643790cb588e9700dac16f35fb0898f8cdac4c733e2611/8.8.3/libexec/x86_64-linux-ghc-8.8.3/TP1-0.1.0.0"
sysconfdir = "/mnt/c/Users/Bautista Marelli/Documents/Facultad/ALP/TrbajosPracticos/TP1/.stack-work/install/x86_64-linux-tinfo6/b1b95b3b867481dc84643790cb588e9700dac16f35fb0898f8cdac4c733e2611/8.8.3/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "TP1_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "TP1_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "TP1_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "TP1_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "TP1_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "TP1_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
