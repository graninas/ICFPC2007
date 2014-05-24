module IcfpcEndo.Constants where

import IcfpcEndo.Endo
import qualified Data.ByteString.Char8 as BS
import qualified Data.Sequence as Seq

iBase = Base 'I'
cBase = Base 'C'
fBase = Base 'F'
pBase = Base 'P'

cPrefix   = BS.pack "C"
fPrefix   = BS.pack "F"
pPrefix   = BS.pack "P"
icPrefix  = BS.pack "IC"
ipPrefix  = BS.pack "IP"
ifPrefix  = BS.pack "IF"
iipPrefix = BS.pack "IIP"
iicPrefix = BS.pack "IIC"
iifPrefix = BS.pack "IIF"