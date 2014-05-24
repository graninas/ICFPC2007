module IcfpcEndo.Wire where

import Application.Game.Engine.Runtime
import Application.Game.Engine.GameWire
import Application.Game.Engine.Core

import Middleware.FRP.NetwireFacade as FRP
import Middleware.SDL.SDLFacade as SDL
import Prelude hiding (id, (.))

data GameNode = Screen1 | Screen2 | Screen3 | Screen4
  deriving (Ord, Eq, Show, Enum)

data Command = Finish
             | Process
  deriving (Ord, Eq, Show)

logic :: GameWire () ()
logic = gameNode Screen1

gameNode :: GameNode -> GameWire () ()
gameNode node = modes Process (selector node) .
            (
                pure () &&& now . interpreter node . pollSdlEvent
            )

-- TODO: move to entry module.
selector _    Finish = quit . diagnose "Finish"
selector node Process = mkEmpty --> gameNode node

-- TODO: move to entry module.
interpreter :: GameNode -> GameWire SDL.Event Command
interpreter node = mkSF_ $ \e -> case e of
    SDL.Quit -> Finish
    _ -> Process

-- TODO: move to entry module.
next Screen4 = Screen1
next node = succ node