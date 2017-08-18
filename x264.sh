#!/bin/sh

#vs2015±àÒë³ÌÐò
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

echo "::download x264"
cd $EXTERA
git clone --depth 1 http://git.videolan.org/git/x264.git



cd x264
SOURCE=$(pwd)
cp -f $ROOT/patch/x264/extras/avisynth_c.h ./extras/avisynth_c.h

echo "::configure"
./configure --help > ../x264.txt
./configure \
--enable-shared \
--enable-static \
--disable-asm \
--prefix=${ROOT}/bin/x264/

echo "::make"
make clean
make -j4

echo "::make install"
make install
echo "::make clean"
make clean