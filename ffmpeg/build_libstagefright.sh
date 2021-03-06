#!/bin/bash

#PLATFORM=darwin
#PLATFORM=linux
case $(uname) in
	"Linux")
	PLATFORM=linux
	;;
	"Darwin")
	PLATFORM=darwin
	;;
	*)
	PLATFORM=windows
	;;
esac

if [ "$NDK" = "" ]; then
    echo NDK variable not set, assuming ${HOME}/android-ndk
    export NDK=${HOME}/android-ndk
fi

echo "Fetching Android system headers"
git clone --depth=1 --branch gingerbread-release https://github.com/CyanogenMod/android_frameworks_base.git ../../android-source/frameworks/base
git clone --depth=1 --branch gingerbread-release https://github.com/CyanogenMod/android_system_core.git ../../android-source/system/core

echo "Fetching Android libraries for linking"
# Libraries from any froyo/gingerbread device/emulator should work
# fine, since the symbols used should be available on most of them.
if [ ! -d "../../android-libs" ]; then
    #if [ ! -f "../update-cm-7.0.3-N1-signed.zip" ]; then
        #wget http://download.cyanogenmod.com/get/update-cm-7.0.3-N1-signed.zip -P../
    #fi
    unzip ../update-cm-7.0.3-N1-signed.zip system/lib/* -d../
    mv ../system/lib ../../android-libs
    rmdir ../system
fi


SYSROOT=$NDK/platforms/android-9/arch-arm
# Expand the prebuilt/* path into the correct one
TOOLCHAIN=`echo $NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/${PLATFORM}-x86_64`
export PATH=$TOOLCHAIN/bin:$PATH
ANDROID_SOURCE=$(pwd)/../../android-source
ANDROID_LIBS=$(pwd)/../../android-libs
ANDROID_STD=$NDK/sources/cxx-stl/gnu-libstdc++/4.9
ABI="armeabi-v7a"
echo "libstagefright detected $ARCH"
if [ "$ARCH" == "armv7a" ]; then
	ABI="armeabi-v7a"
elif [ "$ARCH" == "arm64" ]; then
	ABI="arm64-v8a"
elif [ "$ARCH" == "armv5" ]; then
	ABI="armeabi"
else
	ABI=$ARCH
fi
	
rm -rf ../build/stagefright
mkdir -p ../build/stagefright

DEST=../build/stagefright
FLAGS="--target-os=linux --cross-prefix=arm-linux-androideabi- --arch=arm --cpu=armv7-a"
FLAGS="$FLAGS --sysroot=$SYSROOT --enable-cross-compile --enable-shared"
FLAGS="$FLAGS --disable-avdevice --disable-decoder=h264 --disable-decoder=h264_vdpau --enable-libstagefright-h264 --enable-decoder=libstagefright_h264"
FLAGS="$FLAGS --disable-encoders --disable-muxers --disable-indevs"


EXTRA_CFLAGS="-I$ANDROID_SOURCE/frameworks/base/include -I$ANDROID_SOURCE/system/core/include"
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_SOURCE/frameworks/base/media/libstagefright"
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_SOURCE/frameworks/base/include/media/stagefright/openmax"
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_STD/include -I$ANDROID_STD/libs/$ABI/include"

EXTRA_CFLAGS="$EXTRA_CFLAGS -march=armv7-a -mfloat-abi=softfp -mfpu=neon"
#用于修正代码在高版本可用
EXTRA_CFLAGS="$EXTRA_CFLAGS -fPIC -DHAVE_PTHREADS"

EXTRA_LDFLAGS="-Wl,--fix-cortex-a8 -L$ANDROID_LIBS -Wl,-rpath-link,$ANDROID_LIBS -L$ANDROID_STD/libs/$ABI"
#链接到库使得Android能正确加载
EXTRA_LDFLAGS="$EXTRA_LDFLAGS -lstagefright -lmedia -lstdc++ -lutils -lbinder -lgnustl_static -ldl"
EXTRA_LDFLAGS="$EXTRA_LDFLAGS -fuse-ld=bfd"

EXTRA_CXXFLAGS="-Wno-multichar -fno-exceptions -fno-rtti -DHAVE_PTHREADS"

DEST="$DEST/$ABI"
FLAGS="$FLAGS --prefix=$DEST"

mkdir -p $DEST
echo "current:"$(pwd)
echo $FLAGS --extra-cflags="$EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS" --extra-cxxflags="$EXTRA_CXXFLAGS" > $DEST/info.txt
./configure $FLAGS --extra-cflags="$EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS" --extra-cxxflags="$EXTRA_CXXFLAGS" | tee $DEST/configuration.txt
[ $PIPESTATUS == 0 ] || exit 1
make clean
make -j4 || exit 1
make install
