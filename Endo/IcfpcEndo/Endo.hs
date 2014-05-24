module IcfpcEndo.Endo where

import qualified Data.ByteString.Char8 as BS
import qualified Data.Sequence as S

type Dna = BS.ByteString
data DnaIndex = DnaFrom Int
              | DnaFromTo Int Int

data PatternItem = Base Char
                 | Skip Int
                 | Search Dna
                 | Open
                 | Close
                 
type Pattern = S.Seq PatternItem


data Endo = Endo { endoDna :: Dna
                 , endoDnaIndex :: DnaIndex
                 , endoPattern :: Pattern
                 , endoLevel :: Int
                 }

emptyPattern = S.empty
skipPatternItem = Skip
searchPatternItem = Search
openPatternItem = Open
closePatternItem = Close

mkEndo dna n = Endo dna (DnaFrom n) emptyPattern 0

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

checkPrefix = BS.isPrefixOf

appendPatternItem = (S.<|)







