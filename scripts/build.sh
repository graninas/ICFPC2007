#!/bin/bash

echo "Building..."
cd Endo
ghc -threaded --make -outputdir ../.bin -o ../.bin/Endo Main.hs
cd ..

