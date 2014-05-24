#!/bin/bash

mkdir ./.bin
mkdir ./.bin/Endo
set -e

./scripts/build.sh
./scripts/copy.sh

set +e
