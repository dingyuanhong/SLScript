#!/bin/sh

export ROOT=$(pwd)
if [ ! -d bin ]
then
	mkdir bin
fi

EXTERA=extra
echo '::'$EXTERA
if [ ! -d $EXTERA ]
then
	mkdir $EXTERA
fi

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
cp -f jconfig.vc jconfig.h

echo "::make install"
mkdir $ROOT/bin/
mkdir $ROOT/bin/libjpeg/
mkdir $ROOT/bin/libjpeg/include
cp -f *.h $ROOT/bin/libjpeg/include

PROJECT=project
TARGET=$ROOT/bin/libjpeg
cp -f -r ./$PROJECT/lib/ $TARGET

echo "::make clean"
rm -f -r ./$PROJECT/jpeg/Debug
rm -f -r ./$PROJECT/jpeg/Release
rm -f -r ./$PROJECT/jpeg/x64/
rm -f  ./$PROJECT/jpeg/*.sdf