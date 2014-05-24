module IcfpcEndo.Execution where

import IcfpcEndo.Endo
import IcfpcEndo.Constants

import Application.Game.Engine.Core
import Application.Game.Engine.Runtime
import Application.Game.Engine.GameWire

import qualified Data.ByteString.Char8 as BS
import qualified Data.Sequence as Seq
import Control.Monad (when, unless)

-- Preparing

executeDna = do
    p <- pattern
--    t <- template
--    matchReplace (p, t)
    retR ()

pattern :: GameStateTIO Pattern
pattern = do
    endo@(Endo dna (DnaFrom i) pat lvl) <- getEndo
    case BS.drop i dna of
      dna' | checkPrefix cPrefix dna'  -> shiftDna 1 >> patAppend iBase >> pattern
      dna' | checkPrefix fPrefix dna'  -> shiftDna 1 >> patAppend cBase >> pattern
      dna' | checkPrefix pPrefix dna'  -> shiftDna 1 >> patAppend fBase >> pattern
      dna' | checkPrefix icPrefix dna' -> shiftDna 2 >> patAppend pBase >> pattern
      dna' | checkPrefix ipPrefix dna' -> do
          shiftDna 2
          n <- nat
          patAppend $ skipPatternItem n
          pattern
      dna' | checkPrefix ifPrefix dna' -> do
          shiftDna 3
          s <- consts
          patAppend $ searchPatternItem s
          pattern
      dna' | checkPrefix iipPrefix dna' -> do
          shiftDna 3
          increaseLevel
          patAppend openPatternItem
          pattern
      dna' |    checkPrefix iicPrefix dna'
             || checkPrefix iifPrefix dna' -> do
          shiftDna 3
          if lvl == 0 then getPattern
                      else decreaseLevel >> patAppend closePatternItem >> pattern
      _ -> getPattern
    
template = undefined
matchReplace = undefined

shiftDna n = do
    endo@(Endo _ (DnaFrom i) _ _) <- getEndo
    let endo' = endo { endoDnaIndex = DnaFrom (i + n) }
    putEndo endo'

patAppend patItem = do
    endo@(Endo _ _ pat _) <- getEndo
    let endo' = endo { endoPattern = appendPatternItem patItem pat }
    putEndo endo'

nat = undefined
consts = undefined
increaseLevel = undefined
decreaseLevel = undefined