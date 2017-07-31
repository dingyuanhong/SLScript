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

echo "::download libyuv"
cd $EXTERA
git clone --depth 1 https://github.com/lemenkov/libyuv.git
git pull

cp $ROOT/patch/libyuv_project.zip .
unzip -o libyuv_project.zip -d libyuv

cd libyuv
echo "::copy jpeg"
cp -f -r $OUTPUT/libjpeg ./third_party/jpeg

echo "::make install"
mkdir $OUTPUT/libyuv
cp -f -r ./include $$OUTPUT/libyuv

PROJECT=project/libyuv
TARGET=$$OUTPUT/libyuv/lib
mkdir $TARGET
mkdir $TARGET/Debug
mkdir $TARGET/Release
mkdir $TARGET/x64
mkdir $TARGET/x64/Debug
mkdir $TARGET/x64/Release
cp -f ./$PROJECT/Debug/libyuv.* $TARGET/Debug
cp -f ./$PROJECT/Release/libyuv.* $TARGET/Release
cp -f ./$PROJECT/x64/Debug/libyuv.* $TARGET/x64/Debug
cp -f ./$PROJECT/x64/Release/libyuv.* $TARGET/x64/Release

echo "::make clean"
rm -f -r ./$PROJECT/Debug
rm -f -r ./$PROJECT/Release
rm -f -r ./$PROJECT/x64/
rm -f  ./$PROJECT/*.sdf