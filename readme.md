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

```
source /path/to/vitis/settings64.sh
cd /opt/XRT/build && ./build.sh
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
bash csim.sh
```
