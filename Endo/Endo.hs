module Endo where

import Middleware.Config.Facade
import Application.Boot
import Paths_Endo as P

optionsFile = "./Assets/Data/Options.cfg"

run::IO ()
run = do
    optionsRealFileName <- P.getDataFileName optionsFile
    cfg <- loadConfiguration optionsRealFileName
    boot cfg
    
    putStrLn "All Ok."