benchmark=vadd

fmain="./tapa/apps/$benchmark/$benchmark.cpp"
fhost="./tapa/apps/$benchmark/$benchmark-host.cpp"

tapa_dir=$HOME/Repositories/tapa-utils/tapa
frt_dir=$HOME/Repositories/tapa-utils/fpga-runtime

export LIBRARY_PATH=$LIBRARY_PATH:$tapa_dir/build
export LIBRARY_PATH=$LIBRARY_PATH:$frt_dir/build

export CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:$tapa_dir/src:$frt_dir/build/include

g++ -o $benchmark $fmain $fhost \
	-l tapa -l frt -l glog -l gflags \
	|| exit

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$tapa_dir/build
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$frt_dir/build

./$benchmark

echo "C simulation completed!" && rm ./$benchmark
