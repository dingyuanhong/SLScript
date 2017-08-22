
set ROOT=%~dp0
sh ./nasm.sh

call "%VS140COMNTOOLS%/../../VC/vcvarsall.bat" x86

cd extra/openh264

echo "make::"
make 'OS=msvc' clean
PATH=%PATH%;"../../bin/nasm32/";
set PREFIX=../../bin/openh264_32

dos2unix ./codec/common/*.sh

make 'OS=msvc' 'ARCH=i686' 'PREFIX=%PREFIX%'
echo "make install::"
mkdir "%PREFIX%"
make 'OS=msvc' 'ARCH=i686' 'PREFIX=%PREFIX%' install

mkdir " %PREFIX%/lib/"
mkdir "%PREFIX%/bin/"
cp -f *.lib %PREFIX%/lib/
cp -f *.pdb %PREFIX%/lib/
cp -f *.exe %PREFIX%/bin/
cp -f *.dll %PREFIX%/bin/

cd %ROOT%
