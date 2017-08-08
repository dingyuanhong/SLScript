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
makedir bin
export OUTPUT=$ROOT/bin

#export ANDROID_SDK=D:/AndroidSDK
export ANDROID_NDK=D:/AndroidSDK/android-ndk-r10e
#export ANDROID_NDK=D:/AndroidSDK/ndk-bundle

EXTERA=extra
echo '::'$EXTERA
makedir $EXTERA

cd $EXTERA
echo "::wget ffmpeg"
if [ ! -f ffmpeg-2.7.7.tar.gz ]
then
	echo 
	#wget https://ffmpeg.org/releases/ffmpeg-2.7.7.tar.gz
	#http://ffmpeg.org/releases/ffmpeg-3.3.3.tar.bz2
fi

echo "::unzip"
#tar -xzf ffmpeg-2.7.7.tar.gz
cd ffmpeg-2.7.7
export FFMPEG_ROOT=$(pwd)

cd $ROOT/ffmpeg
echo "::compile"
./compile-ffmpeg.sh armv7a
