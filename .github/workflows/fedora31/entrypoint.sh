#!/bin/sh -l
uname -a 
cat /etc/issue
yum -y install  clang clang-devel clang-libs  llvm llvm-devel llvm-static
yum -y install  libcxx-devel cmake make gcc gcc-c++
yum -y install  pybind11-devel python3 python3-devel python2 python2-devel diffutils
cmake CMakeLists.txt -DLLVMCONFIG=/usr/bin/llvm-config -DBINDER_MOCK_TEST=OFF -DLibClang_INCLUDE_DIRS=/usr/lib64/clang/9.0.1/include
make
ctest .
out=$?
echo ::set-output name=out::$out
