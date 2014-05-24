module Application.Game.Engine.Runtime where

import View.Runtime
import IcfpcEndo.Endo
import Middleware.Config.Facade

import Control.Monad.State (get, put, StateT(..))
import Control.Monad (liftM)

data GameRt = GameRt { grtConfiguration :: Configuration
                     , grtView :: View
                     , grtEndo :: Endo
                     }

type GameStateTIO = StateT GameRt IO

runtime = GameRt

getEndo :: GameStateTIO Endo
getEndo = liftM grtEndo get

putEndo :: Endo -> GameStateTIO ()
putEndo endo = do
    rt <- get
    put $ rt { grtEndo = endo }
    
getView :: GameStateTIO View
getView = liftM grtView get

putView :: View -> GameStateTIO ()
putView view = do
    rt <- get
    put $ rt { grtView = view }