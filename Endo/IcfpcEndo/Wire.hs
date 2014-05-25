{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}

module IcfpcEndo.Wire (logic) where

import Application.Game.Engine.Runtime as Rt
import Application.Game.Engine.GameWire
import Application.Game.Engine.Core

import IcfpcEndo.Execution
import IcfpcEndo.RuntimeSt

import Middleware.FRP.NetwireFacade as FRP
import Middleware.SDL.SDLFacade as SDL
import Prelude hiding (id, (.))
import Control.Monad (liftM)
import Control.Monad.State (get, put)

instance RuntimeSt GameStateTIO where
  getData = Rt.getData
  putData = Rt.putData

data GameNode = Screen1 | Screen2 | Screen3 | Screen4
  deriving (Ord, Eq, Show, Enum)

data Command = Finish
             | Execute
  deriving (Ord, Eq, Show)

logic :: GameWire () ()
logic = gameNode Screen1

gameNode :: GameNode -> GameWire () ()
gameNode node = modes Execute (selector node) .
            (
                pure () &&& now . interpreter node . pollSdlEvent
            )

selector _    Finish = quit . diagnose "Finish"
selector node Execute = mkEmpty . execute --> gameNode node

interpreter :: GameNode -> GameWire SDL.Event Command
interpreter node = mkSF_ $ \e -> case e of
    SDL.Quit -> Finish
    _ -> Execute

next Screen4 = Screen1
next node = succ node

execute :: GameWire () ()
execute = mkGen_ $ const (executeDna >>= retR)


