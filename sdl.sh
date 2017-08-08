#!/bin/sh

#vs2015编译程序
export DEVENV="devenv.exe"
function makedir()
{
	p=$1
	if [ ! -d $p ]
	then
		mkdir $p
	fi
}

export ROOT=$(pwd)
makedir bin
export OUTPUT=$ROOT/bin

EXTERA=extra
echo '::'$EXTERA
makedir $EXTERA

echo "::download sdl"
cd $EXTERA
 
wget http://www.libsdl.org/release/SDL2-2.0.5.tar.gz
rm -r -f SDL2-2.0.5
tar -xzvf SDL2-2.0.5.tar.gz

cd SDL2-2.0.5
SOURCE=$(pwd)

echo "::window build"
echo "::build: ${VS140COMNTOOLS}/../IDE/devenv.exe"
cd VisualC
$DEVENV SDL.sln
cd SDL
#$DEVENV SDL.vcxproj -ProjectConfig "PlatformToolset|v140" -upgrade
cd ../SDLmain
#$DEVENV SDLmain.vcxproj -ProjectConfig "PlatformToolset|v140" -upgrade
cd ..
$DEVENV SDL.sln -project SDL2 -Build "Debug|x64"
$DEVENV SDL.sln -project SDL2 -Build "Debug|Win32"
$DEVENV SDL.sln -project SDL2 -Build "Release|x64"
$DEVENV SDL.sln -project SDL2 -Build "Release|Win32"

$DEVENV SDL.sln -project SDL2main -Build "Debug|x64"
$DEVENV SDL.sln -project SDL2main -Build "Debug|Win32"
$DEVENV SDL.sln -project SDL2main -Build "Release|x64"
$DEVENV SDL.sln -project SDL2main -Build "Release|Win32"

exit

echo "::make install"
makedir $OUTPUT/SDL
makedir $OUTPUT/SDL/include
makedir $OUTPUT/SDL/include/SDL
cp -f $SOURCE/include/*.* $OUTPUT/SDL/include/SDL

PROJECT=$SOURCE/VisualC
TARGET=$OUTPUT/SDL/lib
makedir $TARGET
makedir $TARGET/Debug
makedir $TARGET/Release
makedir $TARGET/x64
makedir $TARGET/x64/Debug
makedir $TARGET/x64/Release
cp -f $PROJECT/Win32/Debug/SDL2* $TARGET/Debug
cp -f $PROJECT/Win32/Release/SDL2* $TARGET/Release
cp -f $PROJECT/x64/Debug/SDL2* $TARGET/x64/Debug
cp -f $PROJECT/x64/Release/SDL2* $TARGET/x64/Release

echo "::make clean"
$PROJECT/clean.sh