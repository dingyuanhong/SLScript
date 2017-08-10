#!/bin/sh

export ARCH=$1

#export ANDROID_NDK=D:/AndroidSDK/android-ndk-r10e
#mac
#export ANDROID_NDK=/Users/cievon/Documents/AndroidSDK/android-ndk-r10e
#linux
export ANDROID_NDK=/data/wwwroot/android-ndk-r10e
export NDK=$ANDROID_NDK

cp ../patch/update-cm-7.0.3-N1-signed.zip .

if [ ! -d ffmpeg-$ARCH ];then
	rm -r -f ffmpeg-$ARCH
	mkdir ffmpeg-$ARCH
	cp -r -f ../extra/ffmpeg-2.7.7/* ./ffmpeg-$ARCH/
fi

cd ffmpeg-$ARCH

chmod +x ./configure
chmod +x ./*.sh
chmod +x ./*.mak
chmod +x ./tools/*

echo "*:拷贝MediaBufferGroup.cpp 至ffmepg加入编译项目中，避免在Android项目中缺少符号"
cp -P ../../android-source/frameworks/base/media/libstagefright/MediaBufferGroup.cpp ./libavcodec/
cp -P ../../android-source/frameworks/base/include/media/stagefright/MediaBufferGroup.h ./libavcodec/
#cp -P ../../android-source/frameworks/base/media/libstagefright/OMXCodec.cpp ./libavcodec/
#cp -P ../../android-source/frameworks/base/include/media/stagefright/OMXCodec.h ./libavcodec/

echo "*:修改libavcodec/Makefile中778行为 OBJS-$'(CONFIG_LIBSTAGEFRIGHT_H264_DECODER)'+= libstagefright.o MediaBufferGroup.o"

../build_libstagefright.sh
