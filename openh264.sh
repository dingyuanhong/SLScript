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
./nasm.sh

makedir bin
export OUTPUT=$ROOT/bin

EXTERA=extra
echo '::'$EXTERA
makedir $EXTERA

echo "::download openh264"
cd $EXTERA
git clone --depth 1 https://github.com/cisco/openh264.git

cd openh264
SOURCE=$(pwd)

WIN_KITS="C:/Program Files (x86)/Windows Kits/8.0/"
export INCLUDE="$INCLUDE;${VS140COMNTOOLS}/../../VC/include;${WIN_KITS}/Include/um;${WIN_KITS}/Include/shared"

echo "::make"
make 'OS=msvc' clean
export PATH="$PATH:$ROOT/bin/nasm32"
export PATH="$PATH:${VS140COMNTOOLS}/../../VC/bin/arm64:${VS140COMNTOOLS}/../IDE"
export LIB="${LIB};${VS140COMNTOOLS}/../../VC/lib/arm64;${WIN_KITS}/Lib/Win8/um/x64;"
make 'OS=msvc' ARCH=x86_64 'ENABLE64BIT=Yes' 'USE_ASM=Yes' 'PREFIX=%ROOT%/bin/openh64_64/'
make install

exit

make clean
export PATH="$ROOT/bin/nasm32;$PATH"
export PATH="$PATH:${VS140COMNTOOLS}/../../VC/bin:${VS140COMNTOOLS}/../IDE"
export LIB="${LIB};${WIN_KITS}/Lib/Win8/um/x86;"
make OS=msvc ARCH=i386 'PREFIX=%ROOT%/bin/openh64_32/'
make install