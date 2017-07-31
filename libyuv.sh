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

echo "::download libyuv"
cd $EXTERA
#git clone --depth 1 https://github.com/lemenkov/libyuv.git
#git pull

cp $ROOT/patch/libyuv_project.zip .
unzip -o libyuv_project.zip -d libyuv

cd libyuv
SOURCE=$(pwd)

echo "::copy jpeg"
cp -f -r $OUTPUT/libjpeg $SOURCE/third_party/jpeg

echo "::window build"
echo "::build: ${VS140COMNTOOLS}/../IDE/devenv.exe"
cd project
cd libyuv
$DEVENV libyuv.sln -project libyuv -Build "Debug|x64"
$DEVENV libyuv.sln -project libyuv -Build "Debug|x86"
$DEVENV libyuv.sln -project libyuv -Build "Release|x64"
$DEVENV libyuv.sln -project libyuv -Build "Release|x86"

echo "::make install"
makedir $OUTPUT/libyuv
cp -f -r $SOURCE/include $OUTPUT/libyuv

PROJECT=$SOURCE/project/libyuv
TARGET=$OUTPUT/libyuv/lib
makedir $TARGET
makedir $TARGET/Debug
makedir $TARGET/Release
makedir $TARGET/x64
makedir $TARGET/x64/Debug
makedir $TARGET/x64/Release
cp -f $PROJECT/Debug/libyuv.* $TARGET/Debug
cp -f $PROJECT/Release/libyuv.* $TARGET/Release
cp -f $PROJECT/x64/Debug/libyuv.* $TARGET/x64/Debug
cp -f $PROJECT/x64/Release/libyuv.* $TARGET/x64/Release

echo "::make clean"
rm -f -r $PROJECT/Debug
rm -f -r $PROJECT/Release
rm -f -r $PROJECT/x64/
rm -f  $PROJECT/*.sdf