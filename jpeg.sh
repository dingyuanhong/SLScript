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

cd $EXTERA
echo "::wget jpeg"
if [ ! -f jpegsr9b.zip ]
then
	wget http://www.ijg.org/files/jpegsr9b.zip
fi

echo "::unzip"
unzip -o jpegsr9b.zip

cp $ROOT/patch/jpeg_project.zip .
unzip -o jpeg_project.zip -d jpeg-9b
rm -f jpeg_project.zip

cd jpeg-9b
SOURCE=$(pwd)
cp -f jconfig.vc jconfig.h

echo "::window build"
echo "::build: ${VS140COMNTOOLS}/../IDE/devenv.exe"
cd project
cd jpeg

$DEVENV jpeg.sln -project jpeg -Build "Debug|x64"
$DEVENV jpeg.sln -project jpeg -Build "Debug|x86"
$DEVENV jpeg.sln -project jpeg -Build "Release|x64"
$DEVENV jpeg.sln -project jpeg -Build "Release|x86"

echo "::make install"
makedir $OUTPUT
makedir $OUTPUT/libjpeg/
makedir $OUTPUT/libjpeg/include
cp -f $SOURCE/*.h $OUTPUT/libjpeg/include

PROJECT=$SOURCE/project
TARGET=$OUTPUT/libjpeg
cp -f -r $PROJECT/lib/ $TARGET

echo "::make clean"
rm -f -r $PROJECT/jpeg/Debug
rm -f -r $PROJECT/jpeg/Release
rm -f -r $PROJECT/jpeg/x64/
rm -f  $PROJECT/jpeg/*.sdf