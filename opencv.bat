
cd extra

rem wget https://github.com/opencv/opencv/archive/3.3.0.tar.gz
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
mkdir build
cd build

rem cmake -G "Visual Studio 14 2015" -DCMAKE_BUILD_TYPE=RELEASE ../

rem vs2015
set DEVENV=devenv.exe
call "%VS140COMNTOOLS%/../../VC/vcvarsall.bat" x86

rem %DEVENV% OpenCV.sln -project "ALL_BUILD" -Build "Debug|x64"
%DEVENV% OpenCV.sln /project ALL_BUILD /build "Debug|Win32"
rem %DEVENV% OpenCV.sln -project ALL_BUILD -Build "Release|x64"
rem %DEVENV% OpenCV.sln -project ALL_BUILD -Build "Release|Win32"

cd ../../../