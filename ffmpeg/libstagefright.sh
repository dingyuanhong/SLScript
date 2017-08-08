#!/bin/sh

ARCH=$1

#export ANDROID_NDK=D:/AndroidSDK/android-ndk-r10e
export ANDROID_NDK=/Users/cievon/Documents/AndroidSDK/android-ndk-r10e
export NDK=$ANDROID_NDK

cp ../patch/update-cm-7.0.3-N1-signed.zip .
cd ffmpeg-$ARCH

chmod +x ./configure
chmod +x ./*.sh
chmod +x ./*.mak
chmod +x ./tools/*

./tools/build_libstagefright clean
