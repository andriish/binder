cmake CMakeLists.txt -DBINDER_TEST_PYTHON_VERSIONS=0 
cmake --build . 
ldd source/binder
ctest 