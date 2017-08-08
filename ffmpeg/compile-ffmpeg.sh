#! /usr/bin/env bash
#
# Copyright (C) 2013-2014 Zhang Rui <bbcallen@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This script is based on projects below
# https://github.com/yixia/FFmpeg-Android
# http://git.videolan.org/?p=vlc-ports/android.git;a=summary

#----------
UNI_BUILD_ROOT=`pwd`
FF_TARGET=$1
FF_TARGET_EXTRA=$2
set -e
set +x

FF_ACT_ARCHS_32="armv5 armv7a x86"
FF_ACT_ARCHS_64="armv5 armv7a arm64 x86 x86_64"
FF_ACT_ARCHS_ALL=$FF_ACT_ARCHS_64

echo_archs() {
    echo "===================="
    echo "[*] check archs"
    echo "===================="
    echo "FF_ALL_ARCHS = $FF_ACT_ARCHS_ALL"
    echo "FF_ACT_ARCHS = $*"
    echo ""
}

echo_usage() {
    echo "Usage:"
    echo "  compile-ffmpeg.sh armv5|armv7a|arm64|x86|x86_64"
    echo "  compile-ffmpeg.sh all|all32"
    echo "  compile-ffmpeg.sh all64"
    echo "  compile-ffmpeg.sh clean"
    echo "  compile-ffmpeg.sh check"
    exit 1
}

echo_nextstep_help() {
    echo ""
    echo "--------------------"
    echo "[*] Finished"
    echo "--------------------"
    echo "# to continue to build ijkplayer, run script below,"
    echo "sh compile-ijk.sh "
}

chmod +x tools/*.sh
chmod +x config/*.sh

#----------
case "$FF_TARGET" in
    "")
        echo_archs armv7a
		if [ ! -d $UNI_BUILD_ROOT/ffmpeg-armv7a ]; then
			mkdir $UNI_BUILD_ROOT/ffmpeg-armv7a
			cp -r -f $FFMPEG_ROOT/* $UNI_BUILD_ROOT/ffmpeg-armv7a
			sh prepare.sh armv7a
		fi
        sh tools/do-compile-ffmpeg.sh armv7a $UNI_BUILD_ROOT
    ;;
    armv5|armv7a|arm64|x86|x86_64)
        echo_archs $FF_TARGET $FF_TARGET_EXTRA
		if [ ! -d $UNI_BUILD_ROOT/ffmpeg-$FF_TARGET ] ; then
			mkdir $UNI_BUILD_ROOT/ffmpeg-$FF_TARGET
			cp -r -f $FFMPEG_ROOT/* $UNI_BUILD_ROOT/ffmpeg-$FF_TARGET
			sh prepare.sh $FF_TARGET
		fi
        sh tools/do-compile-ffmpeg.sh $FF_TARGET $UNI_BUILD_ROOT $FF_TARGET_EXTRA
        echo_nextstep_help
    ;;
    all32)
        echo_archs $FF_ACT_ARCHS_32
        for ARCH in $FF_ACT_ARCHS_32
        do
			if [ ! -d $UNI_BUILD_ROOT/ffmpeg-$ARCH ] ; then
				mkdir $UNI_BUILD_ROOT/ffmpeg-$ARCH
				cp -r -f $FFMPEG_ROOT/* $UNI_BUILD_ROOT/ffmpeg-$ARCH
				sh prepare.sh $ARCH
			fi
            sh tools/do-compile-ffmpeg.sh $ARCH $UNI_BUILD_ROOT $FF_TARGET_EXTRA
        done
        echo_nextstep_help
    ;;
    all|all64)
        echo_archs $FF_ACT_ARCHS_64
        for ARCH in $FF_ACT_ARCHS_64
        do
			if [ ! -d $UNI_BUILD_ROOT/ffmpeg-$ARCH ] ; then
				mkdir $UNI_BUILD_ROOT/ffmpeg-$ARCH
				cp -r -f $FFMPEG_ROOT/* $UNI_BUILD_ROOT/ffmpeg-$ARCH
				sh prepare.sh $ARCH
			fi
            sh tools/do-compile-ffmpeg.sh $ARCH $UNI_BUILD_ROOT $FF_TARGET_EXTRA
        done
        echo_nextstep_help
    ;;
    clean)
        echo_archs FF_ACT_ARCHS_64
        for ARCH in $FF_ACT_ARCHS_ALL
        do
            if [ -d ffmpeg-$ARCH ]; then
                cd ffmpeg-$ARCH && git clean -xdf && cd -
				rm -rf ffmpeg-$ARCH
            fi
        done
        rm -rf ./build/ffmpeg-*
    ;;
    check)
        echo_archs FF_ACT_ARCHS_ALL
    ;;
    *)
        echo_usage
        exit 1
    ;;
esac
