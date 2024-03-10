#!/bin/sh

# My environment script for running TAPA on a CentOS machine
# Source this script before running TAPA

SCRIPT_PWD=$(pwd)

tapa_dir=$SCRIPT_PWD/tapa
frt_dir=$SCRIPT_PWD/fpga-runtime

export GUROBI_HOME="/opt/gurobi1000/linux64"
export PATH="${PATH}:${GUROBI_HOME}/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$GUROBI_HOME/lib"

export LIBRARY_PATH=$LIBRARY_PATH:$tapa_dir/build
export LIBRARY_PATH=$LIBRARY_PATH:$frt_dir/build
export LIBRARY_PATH=$LIBRARY_PATH:/opt/llvm-17/build/lib

export PATH=$PATH:"$tapa_dir/build/backend"
export PATH=$PATH:"$frt_dir/build"
export PATH=$PATH:"$HOME/Build/iverilog"
