module IcfpcEndo.Loader where

import Middleware.Config.Scheme
import Middleware.Config.Facade

import IcfpcEndo.Endo
import Data.ByteString.Char8 as X

endoDnaInfo = strOption endoDna

loadEndo cfg = do
    dnaFile <- extract cfg endoDnaInfo
    dna <- X.readFile dnaFile
    return (Endo dna)
