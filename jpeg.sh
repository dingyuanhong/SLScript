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
unzip -f -o jpegsr9b.zip 

cp $ROOT/patch/jpeg_project.zip .
unzip -f -o jpeg_project.zip -d jpeg-9b
rm -f jpeg_project.zip