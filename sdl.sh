#!/bin/sh

export ROOT=$(pwd)
if [ ! -d bin ]
then
	mkdir bin
fi
export OUTPUT=$ROOT/bin

EXTERA=extra
echo '::'$EXTERA
if [ ! -d $EXTERA ]
then
	mkdir $EXTERA
fi

echo "::download sdl"
cd $EXTERA

wget http://www.libsdl.org/release/SDL2-2.0.5.tar.gz
tar -xzvf SDL2-2.0.5.tar.gz

cd SDL2-2.0.5

echo "::make install"
mkdir $OUTPUT/SDL
mkdir $OUTPUT/SDL/include
mkdir $OUTPUT/SDL/include/SDL
cp -f ./include/*.* $OUTPUT/SDL/include/SDL

PROJECT=VisualC
TARGET=$OUTPUT/SDL/lib
mkdir $TARGET
mkdir $TARGET/Debug
mkdir $TARGET/Release
mkdir $TARGET/x64
mkdir $TARGET/x64/Debug
mkdir $TARGET/x64/Release
cp -f ./$PROJECT/Win32/Debug/SDL2* $TARGET/Debug
cp -f ./$PROJECT/Win32/Release/SDL2* $TARGET/Release
cp -f ./$PROJECT/x64/Debug/SDL2* $TARGET/x64/Debug
cp -f ./$PROJECT/x64/Release/SDL2* $TARGET/x64/Release

echo "::make clean"
./$PROJECT/clean.sh