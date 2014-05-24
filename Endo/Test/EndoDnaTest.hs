{-# LANGUAGE TemplateHaskell #-}

module Main where

import Test.QuickCheck
import Test.QuickCheck.Property
import Test.QuickCheck.All
import Control.Monad

import IcfpcEndo.Endo

prop_basicSubsequence1 = toDna "ICFP" |- (from 0 `to` 2) == toDna "IC"
prop_basicSubsequence2 = toDna "ICFP" |- (from 2 `to` 0) == emptyDna
prop_basicSubsequence3 = toDna "ICFP" |- (from 2 `to` 2) == emptyDna
prop_basicSubsequence4 = toDna "ICFP" |- (from 2 `to` 3) == toDna "F"
prop_basicSubsequence5 = toDna "ICFP" |- only 2          == toDna "F"
prop_basicSubsequence6 = toDna "ICFP" |- (from 2 `to` 6) == toDna "FP"
prop_basicSubsequence7 = toDna "ICFP" |- from 2          == toDna "FP"
prop_basicSubsequence8 = toDna "ICFP" |- only 6          == emptyDna

tests :: IO Bool
tests = $quickCheckAll

runTests = tests >>= \passed -> putStrLn $
  if passed then "All tests passed."
            else "Some tests failed."

main :: IO ()
main = runTests