module IcfpcEndo.Execution where

import IcfpcEndo.Endo
import IcfpcEndo.Constants
import IcfpcEndo.RuntimeSt

import qualified Data.ByteString.Char8 as BS
import qualified Data.Sequence as S
import qualified Data.IORef as IO
import Control.Monad (when, unless, liftM)
import Control.Monad.IO.Class (MonadIO, liftIO)

getPattern :: MonadIO m => RuntimeSt m => m Pattern
getPattern = liftM endoPattern getData

-- Preparing

executeDna :: MonadIO m => RuntimeSt m => m ()
executeDna = do
    endo@(Endo _ _ _ _ act) <- getData
    case act of
        NoDecoding    -> startDecodingAction ParsePattern
        ParsePattern  -> parsePattern
        ParseTemplate -> parseTemplate
        MatchReplace  -> matchReplace

startDecodingAction act = do
    endo <- getData
    putData $ endo { endoDecodingAction = act }

-- It is possible to use Parsec for 'executing' a DNA.
parsePattern :: MonadIO m => RuntimeSt m => m ()
parsePattern = do
    endo@(Endo dnaRef (DnaFrom i) pat lvl act) <- getData
    dna <- liftIO $ IO.readIORef dnaRef
    case BS.drop i dna of
      dna' | checkPrefix cPrefix  dna' -> shiftDna 1 >> patAppend iBasePI
      dna' | checkPrefix fPrefix  dna' -> shiftDna 1 >> patAppend cBasePI
      dna' | checkPrefix pPrefix  dna' -> shiftDna 1 >> patAppend fBasePI
      dna' | checkPrefix icPrefix dna' -> shiftDna 2 >> patAppend pBasePI
      dna' | checkPrefix ipPrefix dna' -> do
          shiftDna 2
          n <- nat
          patAppend $ skipPI n
      dna' | checkPrefix ifPrefix dna' -> do
          shiftDna 3
          s <- consts
          patAppend $ searchPI s
      dna' | checkPrefix iipPrefix dna' -> do
          shiftDna 3
          increaseLevel
          patAppend openPI
      dna' |    checkPrefix iicPrefix dna'
             || checkPrefix iifPrefix dna' -> do
          shiftDna 3
          if lvl == 0 then startDecodingAction ParseTemplate
                      else decreaseLevel >> patAppend closePI
      _ -> startDecodingAction ParseTemplate
    
parseTemplate = undefined
matchReplace = undefined

shiftDna n = do
    endo@(Endo _ (DnaFrom i) _ _ _) <- getData
    let endo' = endo { endoDnaIndex = DnaFrom (i + n) }
    putData endo'

patAppend patItem = do
    endo@(Endo _ _ pat _ _) <- getData
    let endo' = endo { endoPattern = appendPatternItem patItem pat }
    putData endo'

nat = undefined
consts = undefined
increaseLevel = undefined
decreaseLevel = undefined