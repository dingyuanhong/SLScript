#!/bin/sh

export ROOT=$(pwd)
if [ ! -d bin ]
then
	mkdir bin
fi

EXTERA=extra
echo '::'$EXTERA
if [ ! -d $EXTERA ]
then
	mkdir $EXTERA
fi

#download lantern
echo '::download'
cd $EXTERA
git clone --depth=1 https://github.com/getlantern/lantern.git
git pull

OS='window'

cd lantern
export LANTERN_ROOT=$(pwd)

if [ $OS != 'linux' ]
then
	echo '::patch'
	cd $ROOT/patch
	lantern_patch.sh
	
	cd $LANTERN_ROOT
	echo '::make build '
	#make generate-windows-icon
	make windows
	#VERSION=9.9.9
	#export VERSION
	#make package-windows
	
	echo '::make install'
	cp -f *.exe $ROOT/bin
	make clean
else
	HEADLESS=true make package-linux
	HEADLESS=true make package-linux-arm
fi

