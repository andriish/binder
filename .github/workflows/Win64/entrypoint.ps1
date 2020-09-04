echo "HALLO"

wget 'https://ziglang.org/deps/llvm+clang+lld-10.0.0-x86_64-windows-msvc-release-mt.tar.xz'

Expand-Archive -LiteralPath 'llvm+clang+lld-10.0.0-x86_64-windows-msvc-release-mt.tar.xz'

cmake CMakeLists.txt -DBINDER_TEST_PYTHON_VERSIONS=0  -DCMAKE_PREFIX_PATH=llvm+clang+lld-10.0.0-x86_64-windows-msvc-release-mt
cmake --build . 
ldd source/binder
ctest 
echo "END"