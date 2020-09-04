
ls D:/a/_temp/msys/msys64/mingw64/bin/
ls D:/a/_temp/msys/msys64/mingw64/lib/
ls D:/a/_temp/msys/msys64/mingw64/lib64/

cmake CMakeLists.txt -DBINDER_TEST_PYTHON_VERSIONS=0
make
ldd source/binder
ctest 