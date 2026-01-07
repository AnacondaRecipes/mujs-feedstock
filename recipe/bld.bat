@echo on

copy %RECIPE_DIR%\CMakeLists.txt
set LIBRARY_PREFIX_SUB=%LIBRARY_PREFIX:\=/%

make prefix="%LIBRARY_PREFIX%" utfdata.h
if errorlevel 1 exit 1

make prefix="%LIBRARY_PREFIX%" one.c
if errorlevel 1 exit 1

make prefix="%LIBRARY_PREFIX_SUB%" build/release/mujs.pc
if errorlevel 1 exit 1

cmake -B build -GNinja . -S %SRC_DIR% ^
      -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_PREFIX_PATH:PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_BUILD_TYPE:STRING=Release
if errorlevel 1 exit 1

cmake --build build -j
if errorlevel 1 exit 1

cmake --install build
if errorlevel 1 exit 1