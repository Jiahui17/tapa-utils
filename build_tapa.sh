#!/bin/bash

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

