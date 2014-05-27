module IcfpcEndo.Loader where

import IcfpcEndo.Endo (mkEndo)
import Application.Assets.ConfigScheme
import Middleware.Config.Facade

import Paths_Endo as P
import Data.ByteString.Char8 as X
import qualified Data.IORef as IO

endoDnaInfo = strOption endoDna

load cfg = do
    dnaFile <- extract cfg endoDnaInfo
    dnaRealFileName <- P.getDataFileName dnaFile
    dna <- X.readFile dnaRealFileName
    dnaRef <- IO.newIORef dna
    return $ mkEndo dnaRef 0
