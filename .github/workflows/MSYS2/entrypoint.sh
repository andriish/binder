cmake CMakeLists.txt -DBINDER_TEST_PYTHON_VERSIONS=0
make
ldd source/binder
ctest 