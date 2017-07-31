#!/bin/sh

function makedir()
{
	p=$1
	if [ ! -d $p ]
	then
		mkdir $p
	fi
}

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

echo "::download lua"
cd $EXTERA
wget http://www.lua.org/ftp/lua-5.3.4.tar.gz
tar -xzf lua-5.3.4.tar.gz

echo "::patch"
cp $ROOT/patch/lua_project.zip .
unzip -o lua_project.zip -d ./lua-5.3.4

echo "::make install"
cd lua-5.3.4
makedir $OUTPUT/lua
makedir $OUTPUT/lua/include
cp -f ./src/*.h $OUTPUT/lua/include

PROJECT=
TARGET=$OUTPUT/lua/lib
makedir $TARGET
makedir $TARGET/Debug
makedir $TARGET/Release
makedir $TARGET/x64
makedir $TARGET/x64/Debug
makedir $TARGET/x64/Release
cp -f ./$PROJECT/Debug/lua.* $TARGET/Debug
cp -f ./$PROJECT/Release/lua.* $TARGET/Release
cp -f ./$PROJECT/x64/Debug/lua.* $TARGET/x64/Debug
cp -f ./$PROJECT/x64/Release/lua.* $TARGET/x64/Release

echo "::make clean"
rm -f -r ./$PROJECT/Debug
rm -f -r ./$PROJECT/Release
rm -f -r ./$PROJECT/x64/
rm -f  ./$PROJECT/*.sdf