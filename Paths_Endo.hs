module Paths_Endo where

import System.FilePath

-- This module used by cabal-install.

gameDataPath = "./Assets/Data/"

getDataFileName :: FilePath -> IO FilePath
getDataFileName = return . (</>) gameDataPath