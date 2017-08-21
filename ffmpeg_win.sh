#!/bin/sh

#vs2015��������
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

echo "::download ffmepeg"
cd $EXTERA
WGET_NAME=ffmpeg-2.7.7
#ffmpeg-3.3.3

if [ ${PRERESOURCE} ];then
	if [ ! -f ${WGET_NAME}.tar.gz ]
	then
		echo
		wget https://ffmpeg.org/releases/${WGET_NAME}.tar.gz
	fi
	rm -r -f ${WGET_NAME}
	tar -xzf ${WGET_NAME}.tar.gz
fi

cd ${WGET_NAME}
SOURCE=$(pwd)
echo ${SOURCE}

echo "::configure ffmepeg"

EXTRA_PATH=../../bin
EXTRA_CFLAGS="-fPIC -DANDROID -I/usr/local/include"
EXTRA_LDFLAGS="-L/usr/local/lib"
EXTRA_CONFIGURE=""

if [ $(uname) == "MINGW*" ];then
	EXTRA_LDFLAGS="${EXTRA_LDFLAGS} -lmingwex"
elif [ $(uname) == "CYGWIN*" ];then
	EXTRA_LDFLAGS="${EXTRA_LDFLAGS} -lmingwex"
fi

DEBUG=0
SMALL=1
QUICK=1
OS="WINDOWS"

if [ DEBUG ];then
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-debug"
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --disable-memalign-hack"
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --disable-optimizations"
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --disable-stripping"
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --disable-asm"
else
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --disable-debug"
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-optimizations"
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-stripping"
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-asm"
fi
if [ SMALL ];then
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-small"
fi
if [ QUICK ];then
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --disable-ffmpeg"
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --disable-ffplay"
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --disable-ffprobe"
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --disable-ffserver"
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --disable-doc"
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --disable-symver"
fi
if [ ${OS} == "WINDOWS" ];then
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-d3d11va"
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-dxva2"
fi

#EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-libopenjpeg"
EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-libx264"
EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-libopenh264"

EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-decoder=png"
#EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-decoder=libopenjpeg"
EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-decoder=h264"
#EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-decoder=libx264"
#EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-decoder=libx264rgb"
EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-encoder=libx264"
EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-encoder=libx264rgb"
EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-encoder=libopenh264"

ARCH=x86
#ARCH=x86_64

EXTRA_CFLAGS="${EXTRA_CFLAGS} -I${EXTRA_PATH}/libjpeg/include"
if [ $ARCH == "x86_64" ];then
	EXTRA_LDFLAGS="${EXTRA_LDFLAGS} -L${EXTRA_PATH}/libjpeg/x64/Release -ljpeg"
else
	EXTRA_LDFLAGS="${EXTRA_LDFLAGS} -L${EXTRA_PATH}/libjpeg/Release -ljpeg -libpath:${EXTRA_PATH}/libjpeg/Release"
fi

OPENJPEG=
if [ $ARCH == "x86_64" ];then
	OPENJPEG=${EXTRA_PATH}/openjpeg_x64
else
	OPENJPEG=${EXTRA_PATH}/openjpeg_x86
fi
EXTRA_LDFLAGS="${EXTRA_LDFLAGS} -L${OPENJPEG}/lib -lopenjp2 -libpath:${OPENJPEG}/lib"
EXTRA_CFLAGS="${EXTRA_CFLAGS} -I${OPENJPEG}/include/openjpeg-2.2"
if [ ${OS} == 'WINDOWS' ];then
	cp -f ${OPENJPEG}/lib/openjp2.lib ${OPENJPEG}/lib/openjpeg.lib
	PATH=$PATH:${OPENJPEG}/bin/
fi

EXTRA_CFLAGS="${EXTRA_CFLAGS} -I${EXTRA_PATH}/x264/include"
EXTRA_LDFLAGS="${EXTRA_LDFLAGS} -L${EXTRA_PATH}/x264/lib -lx264 -libpath:${EXTRA_PATH}/x264/lib"
if [ ${OS} == 'WINDOWS' ];then
	cp -f "${EXTRA_PATH}/x264/lib/libx264.a" "${EXTRA_PATH}/x264/lib/x264.lib"
	#cp -f "${EXTRA_PATH}/x264/lib/libx264.dll.a" "${EXTRA_PATH}/x264/lib/x264.dll.lib"
	cp -f "${EXTRA_PATH}/x264/lib/libx264.dll.a" "${EXTRA_PATH}/x264/lib/x264.lib"
	PATH=$PATH:${EXTRA_PATH}/x264/bin/
fi
if [ $ARCH == "x86_64" ];then
	EXTRA_CFLAGS="${EXTRA_CFLAGS} -I${EXTRA_PATH}/openh264_64/include"
	EXTRA_LDFLAGS="${EXTRA_LDFLAGS} -L${EXTRA_PATH}/openh264_64/lib -libpath:${EXTRA_PATH}/openh264_64/lib"
else
	EXTRA_CFLAGS="${EXTRA_CFLAGS} -I${EXTRA_PATH}/openh264_32/include"
	EXTRA_LDFLAGS="${EXTRA_LDFLAGS} -L${EXTRA_PATH}/openh264_32/lib -libpath:${EXTRA_PATH}/openh264_32/lib"
fi

if [ ${OS} == 'WINDOWS' ];then
	EXTRA_CONFIGURE="${EXTRA_CONFIGURE} --enable-w32threads"
fi

if [ $ARCH == "x86_64" ];then
	EXTRA_CONFIGURE="$EXTRA_CONFIGURE --arch=x86_64 --host-os=win64"
fi

#C compiler test failed.
#remove cygwin's link.exe

CONFIGURE=0
if [ $CONFIGURE ];then
	export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
	echo "::configure"
	./configure > ../../bin/$WGET_NAME.txt
	./configure \
	--enable-gpl \
	--enable-nonfree \
	--disable-yasm \
	${EXTRA_CONFIGURE} \
	--extra-cflags="${EXTRA_CFLAGS}" \
	--extra-ldflags="${EXTRA_LDFLAGS}" \
	--enable-shared \
	--enable-static \
	--logfile=${EXTRA_PATH}/ffmpeg_config.log \
	--toolchain=msvc \
	--prefix=${ROOT}/bin/ffmpeg/
fi

echo "::make"
make clean
make -j4

echo "::make install"
make install
echo "::make clean"
make clean
