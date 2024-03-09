# Building TAPA on a Centos 7 Machine


## Dependencies


Building these things from source are very difficult.

```
sudo yum install -y glog gflags glog-devel gflags-devel
```

---

Building XRT. We need to get prebuilt `cmake` from source, and change the build
script in the `XRT/build` directory.

```
source settings64.sh
cd XRT/build && ./build.sh
```

