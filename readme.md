# Building TAPA on a Centos 7 Machine

Here is a set of things that I did to make TAPA work on a CentOS 7 server.

## Dependencies

Getting an up-to-date version of [cmake](https://cmake.org/download/). For
instance, I placed the cmake bin at `/opt/cmake-3.28.3-linux-x86_64/bin/cmake`.

---

Building these things from source are not so difficult, but they require more
manual linking if they are built in non-standard locations.

```sh
sudo yum install -y \
	opencl-headers \
	tinyxml tinyxml-devel \
	glog gflags \
	glog-devel gflags-devel
```

---

Building XRT. We need to get prebuilt `cmake` from source, and change the build
script in the `XRT/build` directory. Here I assume that XRT is installed in
`/opt/XRT`

```sh
source /path/to/vitis/settings64.sh
cd /opt/XRT/build && ./build.sh
```

---

Build `llvm-17`. This step is just to make sure that we know where are the
headers to include, maybe we can get the headers using package manager.

```sh
wget https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-17.0.1.tar.gz
tar -xf llvmorg-17.0.1.tar.gz
sudo mv llvmorg-17.0.1 /opt/llvm-17
cd /opt/llvm-17 

source /opt/rh/devtoolset-11/enable
source /opt/rh/llvm-toolset-7.0/enable

CMAKE_FLAGS_SUPER="-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
    -DLLVM_ENABLE_LLD=ON" 
CMAKE_FLAGS_LLVM="$CMAKE_FLAGS_SUPER -DLLVM_CCACHE_BUILD=ON" 
SCRIPT_CWD=$PWD 
BUILD_TYPE=Release 
cd $SCRIPT_CWD && mkdir -p build && cd build 
CMAKE=/opt/cmake-3.28.3-linux-x86_64/bin/cmake 
$CMAKE -G Ninja ../llvm \
	-DLLVM_ENABLE_PROJECTS="clang" \
	-DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind" \
	-DLLVM_TARGETS_TO_BUILD="host" \
	-DCMAKE_BUILD_TYPE=Release \
	-DLLVM_ENABLE_ASSERTIONS=ON \
	$CMAKE_FLAGS_LLVM 
ninja -j $(nproc)
```


## Remove hardcoded LLVM header locations

Assuming that we put llvm in `/opt/llvm-17`, and `fpga-runtime` in
`/opt/fpga-runtime`. Go to `tapa/backend/python/tapa/steps` and change the
hardcoded location to where you install `llvm-17`

```diff 
---  system_includes.extend(
---      ['-isystem', f"/usr/lib/llvm-{match[1]}/include/c++/v1/"]) 
---  system_includes.extend(
---      ['-isystem', f"/usr/include/clang/{match[1]}/include/"])
---  system_includes.extend(['-isystem', f"/usr/lib/clang/{match[1]}/include/"])
+++  system_includes.extend( ['-isystem', f"/opt/llvm-17/build/include/c++/v1"]) 
+++  system_includes.extend( ['-isystem', f"/opt/llvm-17/build/lib/clang/17/include"])
+++  system_includes.extend( ['-isystem', f"/opt/llvm-17/build/include/x86_64-unknown-linux-gnu/c++/v1"])
+++  system_includes.extend( ['-isystem', f"/opt/fpga-runtime/build/include"]) 
```

## Building fpga-runtime and TAPA

Here I wanted to avoid installing anything system-wide since I assume that they
will be changed quite frequently.

```sh
git clone git@github.com:Blaok/fpga-runtime.git
bash build_frt.sh
```

---

```sh
git clone git@github.com:UCLA-VAST/tapa.git
bash build_tapa.sh
```

## Run the first example

```sh
source env.sh
cd tapa/apps/vadd
bash run_tapa.sh
```
