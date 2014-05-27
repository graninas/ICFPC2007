module IcfpcEndo.RuntimeSt where

import IcfpcEndo.Endo

class Monad m => RuntimeSt m where
  getData :: m Endo
  putData :: Endo -> m ()

