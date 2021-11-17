#!/bin/sh -l
set -x
uname -a 
cat /etc/issue
apt -y update
add-apt-repository -y universe multiverse
apt -y update
apt-get -y install  git  zlib1g zlib1g-dev ncurses-dev  clang libclang-dev clang-libs  llvm llvm-dev
apt-get -y install  cmake make gcc gcc-c++
apt-get -y install  pybind11-dev python python-dev 

cmake CMakeLists.txt
make
ldd source/binder
ldd -u -r source/binder
ctest . --output-on-failure 
out=$?
cat Testing/Temporary/LastTest.log
echo ::set-output name=out::$out
