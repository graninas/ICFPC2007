module IcfpcEndo.RuntimeSt where

import Control.Monad.State.Class
import IcfpcEndo.Endo

class Monad m => RuntimeSt m where
  getData :: m Endo
  putData :: Endo -> m ()