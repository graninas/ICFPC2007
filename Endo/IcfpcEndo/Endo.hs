module IcfpcEndo.Endo where

import qualified Data.ByteString.Char8 as BS

type Dna = BS.ByteString
data Endo = Endo Dna

data DnaIndex = DnaFrom Int
              | DnaFromTo Int Int




toDna :: String -> Dna
toDna = BS.pack

emptyDna :: Dna
emptyDna = BS.empty

from :: Int -> DnaIndex
from = DnaFrom

to :: DnaIndex -> Int -> DnaIndex
to (DnaFrom i) = DnaFromTo i

only :: Int -> DnaIndex
only i = DnaFromTo i (i + 1)

(|-) :: Dna -> DnaIndex -> Dna
dna |- (DnaFrom i)     = BS.drop i dna
dna |- (DnaFromTo i k) = BS.take (k - i) . BS.drop i $ dna