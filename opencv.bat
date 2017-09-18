
cd extra

wget https://github.com/opencv/opencv/archive/3.3.0.tar.gz
rem wget https://github.com/opencv/opencv/archive/3.3.0.zip

cd opencv-3.3.0

set CMAKE_NAME=cmake-3.9.1-win32-x86
call cmake32.bat

echo "make::"
PATH=%PATH%;"../../%CMAKE_NAME%/bin/";
echo "::cmake"
rm -f CMakeCache.txt
rm -f -r CMakeFiles
mkdir "../../bin/opencv_x86/"

rem Win64
mkdir ./build
cd build

cmake -G "Visual Studio 14 2015" -DCMAKE_BUILD_TYPE=RELEASE ../


cd ../../../