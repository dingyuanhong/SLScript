#!/bin/sh

#vs2015±‡“Î≥Ã–Ú
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

cd $EXTERA
echo "::wget ffmpeg"
if [ ! -f ffmpeg-2.7.7.tar.gz ]
then
	
	wget https://ffmpeg.org/releases/ffmpeg-2.7.7.tar.gz
fi

echo "::unzip"
tar -xzf ffmpeg-2.7.7.tar.gz
cd ffmpeg-2.7.7
export FFMPEG_ROOT=$(pwd)

cd $ROOT/ffmpeg
echo "::compile"
./compile-ffmpeg-win.sh
