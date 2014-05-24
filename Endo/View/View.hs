module View.View where

import View.Color
import View.Runtime

import qualified Middleware.SDL.SDLFacade as SDL
import qualified Middleware.SDL.Render as SDL
import qualified Middleware.Tracing.Log as Log
import Middleware.Tracing.ErrorHandling

import qualified Data.Map as M

setupView :: (Screen, String, ViewPoint) -> IO View
setupView (scr@(Screen w h bpp), caption, virtualPlane) = do
    surface <- SDL.setVideoMode w h bpp [SDL.SWSurface]
    SDL.setCaption caption []
    SDL.flip surface
    return $ View surface scr caption virtualPlane Nothing
