export ROOT=$(pwd)
cd extra

if [ ! -f nasm-2.14rc0-win32.zip ]
then
	wget http://www.nasm.us/pub/nasm/releasebuilds/2.14rc0/win32/nasm-2.14rc0-win32.zip
fi

unzip -o nasm-2.14rc0-win32.zip -d ${ROOT}/bin/nasm32
mv -f ${ROOT}/bin//nasm32/nasm-2.14rc0/* ${ROOT}/bin/nasm32

if [ ! -f nasm-2.14rc0-win64.zip ]
then
	wget http://www.nasm.us/pub/nasm/releasebuilds/2.14rc0/win64/nasm-2.14rc0-win64.zip
fi

unzip -o nasm-2.14rc0-win64.zip -x nasm-2.14rc0 -d ${ROOT}/bin/nasm64
mv -f ${ROOT}/bin/nasm64/nasm-2.14rc0/* ${ROOT}/bin/nasm64