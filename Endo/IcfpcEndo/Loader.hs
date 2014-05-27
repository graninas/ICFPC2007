module IcfpcEndo.Loader where

import IcfpcEndo.Endo (mkEndo)
import Application.Assets.ConfigScheme
import Middleware.Config.Facade

import Paths_Endo as P
import Data.ByteString.Char8 as X

endoDnaInfo = strOption endoDna

load cfg = do
    dnaFile <- extract cfg endoDnaInfo
    dnaRealFileName <- P.getDataFileName dnaFile
    dna <- X.readFile dnaRealFileName
    return $ mkEndo dna 0
