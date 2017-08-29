
set ROOT=%~dp0
sh ./nasm.sh

call "%VS140COMNTOOLS%/../../VC/vcvarsall.bat" amd64

cd extra/openh264
echo "make::"
make 'OS=msvc' clean
set PATH=%PATH%;%ROOT%/bin/nasm64/;
set PREFIX=../../bin/openh264_64

dos2unix ./codec/common/*.sh

make -j4 'OS=msvc' 'ARCH=x86_64' 'ENABLE64BIT=Yes' 'USE_ASM=Yes' 'PREFIX=%PREFIX%'

echo "make install::"
mkdir "%PREFIX%"
make 'OS=msvc' 'ARCH=x86_64' 'ENABLE64BIT=Yes' 'USE_ASM=Yes' 'PREFIX=%PREFIX%' install

mkdir " %PREFIX%/lib/"
mkdir "%PREFIX%/bin/"
cp -f *.lib %PREFIX%/lib/
cp -f *.pdb %PREFIX%/lib/
cp -f *.exe %PREFIX%/bin/
cp -f *.dll %PREFIX%/bin/

cd %ROOT%
