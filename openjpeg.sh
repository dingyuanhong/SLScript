
#!/bin/sh
#编译方法
#http://blog.csdn.net/10km/article/details/50581246

#vs2015
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

echo "::download openjpeg"
cd $EXTERA
git clone --depth 1 https://github.com/uclouvain/openjpeg.git

CMAKE_NAME=cmake-3.9.1-win64-x64
if [ ! -f ${CMAKE_NAME}.zip ];then
  wget https://cmake.org/files/v3.9/${CMAKE_NAME}.zip
  unzip ${CMAKE_NAME}.zip
fi
CMAKE_NAME=cmake-3.9.1-win32-x86
if [ ! -f ${CMAKE_NAME}.zip ];then
  wget https://cmake.org/files/v3.9/${CMAKE_NAME}.zip
  unzip ${CMAKE_NAME}.zip
fi
