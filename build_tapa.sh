#!/bin/bash

SCRIPT_CWD=$(pwd)

set -e

[ -d tapa ]

cd tapa

CMAKE="/opt/cmake-3.28.3-linux-x86_64/bin/cmake"

export CXXFLAGS=-isystem\ $(pwd)/../fpga-runtime/build/include

echo $CXXFLAGS
#exit

export CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:$(pwd)/../fpga-runtime/build/include

$CMAKE -GNinja -S . -Bbuild \
	-DCMAKE_PREFIX_PATH=../fpga-runtime/build/lib/cmake/frt \

cd build
ninja
ninja test

cd $SCRIPT_CWD

python3.10 -m venv .venv
source .venv/bin/activate
python3 -m pip install pip --upgrade

python3 -m pip install -e tapa/backend/python
