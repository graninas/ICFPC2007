{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}

module Main where

import Test.QuickCheck
import Test.QuickCheck.Property
import Test.QuickCheck.All
import Control.Monad
import Control.Monad.State
import Control.Monad.Identity

import qualified Data.ByteString.Char8 as BS
import qualified Data.Sequence as S

import IcfpcEndo.Endo
import IcfpcEndo.RuntimeSt
import IcfpcEndo.Execution
import IcfpcEndo.Constants

--import Application.Game.Engine.Runtime

prop_basicSubsequence1 = toDna "ICFP" |- (from 0 `to` 2) == toDna "IC"
prop_basicSubsequence2 = toDna "ICFP" |- (from 2 `to` 0) == emptyDna
prop_basicSubsequence3 = toDna "ICFP" |- (from 2 `to` 2) == emptyDna
prop_basicSubsequence4 = toDna "ICFP" |- (from 2 `to` 3) == toDna "F"
prop_basicSubsequence5 = toDna "ICFP" |- only 2          == toDna "F"
prop_basicSubsequence6 = toDna "ICFP" |- (from 2 `to` 6) == toDna "FP"
prop_basicSubsequence7 = toDna "ICFP" |- from 2          == toDna "FP"
prop_basicSubsequence8 = toDna "ICFP" |- only 6          == emptyDna

data TestRuntime = Rt { rtEndo :: Endo }
type TestRuntimeSt = State TestRuntime

instance RuntimeSt TestRuntimeSt where
  getData = liftM rtEndo get
  putData = put . Rt

testRt1 = Rt $ mkEndo (toDna "CIIC") 0
testRt2 = Rt $ mkEndo (toDna "IIPIPICPIICICIIF") 0

testPattern1, testPattern2 :: Pattern
testPattern1 = evalState pattern testRt1
testPattern2 = evalState pattern testRt2

prop_execution1 = testPattern1 == toPattern [iBasePI]
prop_execution2 = testPattern2 == toPattern [openPI, skipPI 2, closePI, pBasePI]

tests :: IO Bool
tests = $quickCheckAll

runTests = tests >>= \passed -> putStrLn $
  if passed then "All tests passed."
            else "Some tests failed."

main :: IO ()
main = runTests