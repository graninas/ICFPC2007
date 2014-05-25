module IcfpcEndo.Execution where

import IcfpcEndo.Endo
import IcfpcEndo.Constants
import IcfpcEndo.RuntimeSt

import qualified Data.ByteString.Char8 as BS
import qualified Data.Sequence as S
import Control.Monad (when, unless, liftM)

getPattern :: RuntimeSt m => m Pattern
getPattern = liftM endoPattern getData

-- Preparing

executeDna :: RuntimeSt m => m ()
executeDna = do
    p <- pattern
--    t <- template
--    matchReplace (p, t)
    return ()

-- It is possible to use Parsec for 'executing' a DNA.
pattern :: RuntimeSt m => m Pattern
pattern = do
    endo@(Endo dna (DnaFrom i) pat lvl) <- getData
    case BS.drop i dna of
      dna' | checkPrefix cPrefix  dna' -> shiftDna 1 >> patAppend iBasePI >> pattern
      dna' | checkPrefix fPrefix  dna' -> shiftDna 1 >> patAppend cBasePI >> pattern
      dna' | checkPrefix pPrefix  dna' -> shiftDna 1 >> patAppend fBasePI >> pattern
      dna' | checkPrefix icPrefix dna' -> shiftDna 2 >> patAppend pBasePI >> pattern
      dna' | checkPrefix ipPrefix dna' -> do
          shiftDna 2
          n <- nat
          patAppend $ skipPI n
          pattern
      dna' | checkPrefix ifPrefix dna' -> do
          shiftDna 3
          s <- consts
          patAppend $ searchPI s
          pattern
      dna' | checkPrefix iipPrefix dna' -> do
          shiftDna 3
          increaseLevel
          patAppend openPI
          pattern
      dna' |    checkPrefix iicPrefix dna'
             || checkPrefix iifPrefix dna' -> do
          shiftDna 3
          if lvl == 0 then getPattern
                      else decreaseLevel >> patAppend closePI >> pattern
      _ -> getPattern
    
template = undefined
matchReplace = undefined

shiftDna n = do
    endo@(Endo _ (DnaFrom i) _ _) <- getData -- getEndo
    let endo' = endo { endoDnaIndex = DnaFrom (i + n) }
    putData endo'

patAppend patItem = do
    endo@(Endo _ _ pat _) <- getData -- getEndo
    let endo' = endo { endoPattern = appendPatternItem patItem pat }
    putData endo'

nat = undefined
consts = undefined
increaseLevel = undefined
decreaseLevel = undefined