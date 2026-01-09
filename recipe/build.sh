#!/bin/bash
make prefix="${PREFIX}" -j ${CPU_COUNT} install-shared

# Fix macOS dylib install name
if [[ "$target_platform" == osx* ]]; then
    install_name_tool -id @rpath/libmujs.dylib $PREFIX/lib/libmujs.dylib
fi