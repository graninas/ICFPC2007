module IcfpcEndo.Constants where

import IcfpcEndo.Endo
import qualified Data.ByteString.Char8 as BS
import qualified Data.Sequence as Seq

iBasePI = Base 'I'
cBasePI = Base 'C'
fBasePI = Base 'F'
pBasePI = Base 'P'
skipPI = Skip
searchPI = Search
openPI = Open
closePI = Close

cPrefix   = BS.pack "C"
fPrefix   = BS.pack "F"
pPrefix   = BS.pack "P"
icPrefix  = BS.pack "IC"
ipPrefix  = BS.pack "IP"
ifPrefix  = BS.pack "IF"
iipPrefix = BS.pack "IIP"
iicPrefix = BS.pack "IIC"
iifPrefix = BS.pack "IIF"