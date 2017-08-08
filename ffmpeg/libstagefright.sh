ARCH=$1

export ANDROID_NDK=D:/AndroidSDK/android-ndk-r10e
export NDK=$ANDROID_NDK

cd ffmpeg-$ARCH

./tools/build_libstagefright make
