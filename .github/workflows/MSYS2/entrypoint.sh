set -x
#ls D:/a/_temp/msys/msys64/mingw64/bin/
#ls D:/a/_temp/msys/msys64/mingw64/lib/
#ls D:/a/_temp/msys/msys64/mingw64/lib64/

ls D:/a/_temp/msys/msys64/mingw64/bin/libLLVM.*

ls D:/a/_temp/msys/msys64/mingw64/lib/libLLVM.*


cmake CMakeLists.txt -DBINDER_TEST_PYTHON_VERSIONS=0
cmake --build . 
ldd source/binder
ctest 