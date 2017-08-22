rem 编译方法
rem http://blog.csdn.net/10km/article/details/50581246

call "%VS140COMNTOOLS%/../../VC/vcvarsall.bat" amd64

rem git clone --depth 1 https://github.com/uclouvain/openjpeg.git

set CMAKE_NAME=cmake-3.9.1-win64-x64

rem wget https://cmake.org/files/v3.9/%CMAKE_NAME%.zip
rem unzip %CMAKE_NAME%.zip

cd extra/openjpeg

echo "make::"
PATH=%PATH%;"../%CMAKE_NAME%/bin/";
echo "::cmake"
rem rm -f CMakeCache.txt
rem rm -f -r CMakeFiles
mkdir "../../bin/openjpeg_x64/"

rem -DBUILD_SHARED_LIBS=ON  shared
rem -DBUILD_SHARED_LIBS=OFF static
cmake -G "NMake Makefiles" -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=../../bin/openjpeg_x64/ -DCMAKE_BUILD_TYPE=RELEASE .

nmake clean
nmake
nmake install

cd ../../
