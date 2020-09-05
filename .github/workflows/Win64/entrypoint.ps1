echo "HALLO"

wget 'https://ziglang.org/deps/llvm+clang+lld-10.0.0-x86_64-windows-msvc-release-mt.tar.xz' -UseBasicParsing  -OutFile 'llvm+clang+lld-10.0.0-x86_64-windows-msvc-release-mt.tar.xz'
#https://github.com/ziglang/zig/wiki/Building-Zig-on-Windows
7z.exe e  'llvm+clang+lld-10.0.0-x86_64-windows-msvc-release-mt.tar.xz' -y
7z.exe x  'llvm+clang+lld-10.0.0-x86_64-windows-msvc-release-mt.tar' -y

cmake CMakeLists.txt -DBINDER_TEST_PYTHON_VERSIONS=0  -DCMAKE_PREFIX_PATH=llvm+clang+lld-10.0.0-x86_64-windows-msvc-release-mt
cmake --build . 
ldd source/binder
ctest 
echo "END"