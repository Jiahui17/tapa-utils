benchmark=vadd

tapa_dir=$HOME/Repositories/tapa-utils/tapa
frt_dir=$HOME/Repositories/tapa-utils/fpga-runtime

fmain="./tapa/apps/$benchmark/$benchmark.cpp"
fhost="./tapa/apps/$benchmark/$benchmark-host.cpp"

#---------------------------------------------------------------------#

source .venv/bin/activate

export CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:$tapa_dir/src:$frt_dir/build/include
export LIBRARY_PATH=$LIBRARY_PATH:$tapa_dir/build
export LIBRARY_PATH=$LIBRARY_PATH:$frt_dir/build

export PATH=$PATH:"$(pwd)/tapa/build/backend":"$(pwd)/fpga-runtime/build"

platform=xilinx_u250_xdma_201830_2  # replace with your target platform
tapac -o $benchmark.$platform.hw.xo $fmain \
	--platform $platform \
	--top VecAdd \
	--work-dir $benchmark.$platform.hw.xo.tapa

