#!/bin/sh -l
set -x
uname -a 
cat /etc/issue
apt -y update
add-apt-repository -y universe multiverse
apt -y update
apt-get -y install  git  zlib1g zlib1g-dev ncurses-dev clang llvm libclang-dev llvm-dev llvm-runtime
apt-get -y install  cmake make gcc 
apt-get -y install  pybind11-dev python python-dev 
ls /usr/lib/llvm-6.0/bin/../lib/

cmake CMakeLists.txt -DCMAKE_FIND_STATIC=LAST -DCMAKE_FIND_LIBRARY_SUFFIXES=.so
make
ldd source/binder
ldd -u -r source/binder
ctest . --output-on-failure 
out=$?
cat Testing/Temporary/LastTest.log
echo ::set-output name=out::$out
