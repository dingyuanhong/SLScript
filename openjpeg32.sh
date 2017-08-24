#!/bin/sh

# 编译方法
# http://blog.csdn.net/10km/article/details/50581246

CMAKE_NAME=cmake-3.9.1-win32-x86

cd extra/openjpeg

echo "make::"
PATH="$PATH:../$CMAKE_NAME/bin/";
echo "::cmake"
rm -f CMakeCache.txt
rm -f -r CMakeFiles

PREFIX=../../bin/openjpeg_x86/
mkdir "$PREFIX"

# -DBUILD_SHARED_LIBS=ON  shared
# -DBUILD_SHARED_LIBS=OFF static
MAKEFILE=
if [[ $(uname) == MINGW* ]];then
  MAKEFILE="MSYS Makefiles"
elif [[ $(uname) == CYGWIN* ]];then
  MAKEFILE="Unix Makefiles"
else
  MAKEFILE="NMake Makefiles"
fi
echo $MAKEFILE
cmake -G "$MAKEFILE" -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=RELEASE .

make clean
make CFLAGS="-DWIN32 -D__MSVCRT__ %CFLAGS%"
make install

cd ../../
