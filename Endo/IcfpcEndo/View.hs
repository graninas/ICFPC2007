module IcfpcEndo.View where

import View.Color
import View.Runtime
import IcfpcEndo.Endo

import qualified Middleware.SDL.SDLFacade as SDL
import qualified Middleware.SDL.Render as SDL
import qualified Middleware.Tracing.Log as Log
import Middleware.Tracing.ErrorHandling

renderEndo (View surf _ _ vPlane mbShift) _ = undefined