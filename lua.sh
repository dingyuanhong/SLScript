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

echo "::download lua"
cd $EXTERA
wget http://www.lua.org/ftp/lua-5.3.4.tar.gz
tar -xzf lua-5.3.4.tar.gz

echo "::patch"
cp $ROOT/patch/lua_project.zip .
unzip -o lua_project.zip -d ./lua-5.3.4

cd lua-5.3.4
SOURCE=$(pwd)

echo "::window build"
echo "::build: ${VS140COMNTOOLS}/../IDE/devenv.exe"

$DEVENV lua.sln -project lua -Build "Debug|x64"
$DEVENV lua.sln -project lua -Build "Debug|x86"
$DEVENV lua.sln -project lua -Build "Release|x64"
$DEVENV lua.sln -project lua -Build "Release|x86"


echo "::make install"
makedir $OUTPUT/lua
makedir $OUTPUT/lua/include
cp -f $SOURCE/src/*.h $OUTPUT/lua/include

PROJECT=$SOURCE
TARGET=$OUTPUT/lua/lib
makedir $TARGET
makedir $TARGET/Debug
makedir $TARGET/Release
makedir $TARGET/x64
makedir $TARGET/x64/Debug
makedir $TARGET/x64/Release
cp -f $PROJECT/Debug/lua.* $TARGET/Debug
cp -f $PROJECT/Release/lua.* $TARGET/Release
cp -f $PROJECT/x64/Debug/lua.* $TARGET/x64/Debug
cp -f $PROJECT/x64/Release/lua.* $TARGET/x64/Release

echo "::make clean"
rm -f -r $PROJECT/Debug
rm -f -r $PROJECT/Release
rm -f -r $PROJECT/x64/
rm -f  $PROJECT/*.sdf