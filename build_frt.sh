#!/bin/bash

set -e

[ -d fpga-runtime ]
cd fpga-runtime

CMAKE="/opt/cmake-3.28.3-linux-x86_64/bin/cmake"

export XILINX_XRT="/opt/XRT/build/Debug/opt/xilinx/xrt"

$CMAKE . -Bbuild \
	-DCMAKE_INSTALL_PREFIX=./build
$CMAKE --build build
$CMAKE --install build
