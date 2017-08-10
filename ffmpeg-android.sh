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
#export ANDROID_NDK=D:/AndroidSDK/android-ndk-r10e
#export ANDROID_NDK=D:/AndroidSDK/ndk-bundle
#mac
#export ANDROID_NDK=/Users/cievon/Documents/AndroidSDK/android-ndk-r10e
#linux
export ANDROID_NDK=/data/wwwroot/android-ndk-r10e

EXTERA=extra
echo '::'$EXTERA
makedir $EXTERA

cd $EXTERA
PACKET_NAME=ffmpeg-2.7.7
#PACKET_NAME=ffmpeg-3.3.3
echo "::wget ffmpeg"
if [ ! -f ${PACKET_NAME}.tar.gz ]
then
	echo ""
	#wget https://ffmpeg.org/releases/${PACKET_NAME}.tar.gz
	#http://ffmpeg.org/releases/$PACKET_NAME.tar.bz2
fi
echo "::unzip"
#tar -xzf ${PACKET_NAME}.tar.gz

echo "::set"
cd ${PACKET_NAME}
export FFMPEG_ROOT=$(pwd)

cd $ROOT/ffmpeg
echo "::compile"
chmod +x ./*.sh
./compile-ffmpeg.sh armv7a
