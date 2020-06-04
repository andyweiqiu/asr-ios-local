#!/bin/bash

# ios-configure runs a "configure" script using the iOS 4.3 SDK, generating a 
# static library that will load and run on your choice of iPhone, iPad, and 
# their respective simulators.
#
# Simply run in the same directory as a "configure" script.
# You can run this script for multiple targets and use lipo(1) to stitch them 
# together into a universal library.
# 
# Collected and maintained by Nolan Waite (nolan@nolanw.ca)
# 
# Magic compiler flags and incantations by Michael Aaron Safyan 
# (michaelsafyan@gmail.com). Generality by Christopher J. Stawarz
# (http://pseudogreen.org/bzr/sandbox/iphone/build_for_iphoneos)
# 

#default_gcc_version=4.2.1
#default_ios_version=12.1
#default_min_ios_version=12.1
#default_macosx_version=10.14
#
#GCC_VERSION="${GCC_VERSION:-$default_gcc_version}"
#export IOS_VERSION="${IOS_VERSION:-$default_ios_version}"
#export MIN_IOS_VERSION="${MIN_IOS_VERSION:-$default_min_ios_version}"
#export MACOSX_VERSION="${MACOSX_VERSION:-$default_macosx_version}"
#
#DEVELOPER=`xcode-select -print-path`
#
#usage ()
#{
#  cat >&2 << EOF
#Usage: ${0##*/} [-h] [-p prefix] target [configure_args]
#  -h      Print help message
#  -p      Installation prefix
#          (default: `pwd`/build/[target]-[version])
#
#The target must be one of "iphone", "ipad", or "simulator". Any additional
#arguments are passed to configure.
#
#The following environment variables affect the build process:
#
#  GCC_VERSION           (default: $default_gcc_version)
#  IOS_VERSION           (default: $default_ios_version)
#  MIN_IOS_VERSION       (default: $default_min_ios_version)
#  MACOSX_VERSION        (default: $default_macosx_version)
#
#EOF
#}
#
#while getopts ":hp:t" opt; do
#    case $opt in
#        h  ) usage ; exit 0 ;;
#        p  ) prefix="$OPTARG" ;;
#        \? ) usage ; exit 2 ;;
#    esac
#done
#shift $(( $OPTIND - 1 ))
#
#if (( $# < 1 )); then
#    usage
#    exit 2
#fi
#
#target=$1
#shift
#
#case $target in
#    iphone )
#        arch=arm64
#        platform=iPhoneOS
#        host=arm-apple-darwin10
#        ;;
#
#    ipad )
#        arch=arm64
#        platform=iPhoneOS
#        host=arm-apple-darwin10
#        ;;
#
#    simulator )
#        arch=i686
#        platform=iPhoneSimulator
#        host=i686-apple-darwin10
#        ;;
#    * )
#        usage
#        exit 2
#esac
#
#export DEVROOT="/$DEVELOPER/Platforms/${platform}.platform/Developer"
#export SDKROOT="$DEVROOT/SDKs/${platform}${IOS_VERSION}.sdk"
#prefix="${prefix:-`pwd`/build/${target}-${IOS_VERSION}}"
#
#if [ ! \( -d "$DEVROOT" \) ] ; then
#   echo "The iPhone SDK could not be found. Folder \"$DEVROOT\" does not exist."
#   exit 1
#fi
#
#if [ ! \( -d "$SDKROOT" \) ] ; then
#   echo "The iPhone SDK could not be found. Folder \"$SDKROOT\" does not exist."
#   exit 1
#fi
#
#if [ ! \( -x "./configure" \) ] ; then
#    echo "This script must be run in the folder containing the \"configure\" script."
#    exit 1
#fi
#
#export PKG_CONFIG_PATH="$SDKROOT/usr/lib/pkgconfig"
#export PKG_CONFIG_LIBDIR="$PKG_CONFIG_PATH"
#export AS="$DEVROOT/usr/bin/as"
#export ASCPP="$DEVROOT/usr/bin/as"
#export AR="$DEVROOT/usr/bin/ar"
#export RANLIB="$DEVROOT/usr/bin/ranlib"
#export CPPFLAGS="-miphoneos-version-min=${MIN_IOS_VERSION} -pipe -no-cpp-precomp -I$SDKROOT/usr/include"
#export CFLAGS="$CPPFLAGS -std=c99 -arch ${arch} -isysroot $SDKROOT -isystem $SDKROOT/usr/include"
#export CXXFLAGS="$CPPFLAGS -arch ${arch} -isysroot $SDKROOT -isystem $SDKROOT/usr/include"
#export LDFLAGS="-miphoneos-version-min=${MIN_IOS_VERSION} -arch ${arch} -isysroot $SDKROOT -L$SDKROOT/usr/lib -L$DEVROOT/usr/lib"
#export CPP="$DEVROOT/usr/bin/cpp"
#export CXXCPP="$DEVROOT/usr/bin/cpp"
#export CC="$DEVROOT/usr/bin/gcc-${GCC_VERSION}"
#export CXX="$DEVROOT/usr/bin/g++-${GCC_VERSION}"
#export LD="$DEVROOT/usr/bin/ld"
#export STRIP="$DEVROOT/usr/bin/strip"
#
##./configure \
##    --prefix="$prefix" \
##    --host="${host}" \
##    --enable-static \
##    --disable-shared \
##    "$@" || exit


#export XCODEDIR=`xcode-select --print-path`
#
#export IPHONEOS_PLATFORM=${XCODEDIR}/Platforms/iPhoneOS.platform
#export IPHONEOS_SYSROOT=${IPHONEOS_PLATFORM}/Developer/SDKs/iPhoneOS12.1.sdk

if [ ! \( -x "./configure" \) ] ; then
    echo "This script must be run in the folder containing the \"configure\" script."
    exit 1
fi

export DEVROOT=`xcode-select --print-path`
export SDKROOT=$DEVROOT/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk

# Set up relevant environment variables
export CPPFLAGS="-I$SDKROOT/usr/include/c++/4.2.1/ -I$SDKROOT/usr/include/ -miphoneos-version-min=10.0 -arch arm64"
export CFLAGS="$CPPFLAGS -arch arm64 -pipe -no-cpp-precomp -isysroot $SDKROOT"
#export CXXFLAGS="$CFLAGS"
export CXXFLAGS="$CFLAGS  -std=c++11 -stdlib=libc++"

#ARCHS="arm64 armv7"
#ARCH="arm64"
#DEPLOYMENT_TARGET="10.0"
#PLATFORM="iPhoneOS"
#
#XCRUN_SDK=`echo $PLATFORM | tr '[:upper:]' '[:lower:]'`
#
#export CC="xcrun -sdk $XCRUN_SDK clang"
#export CFLAGS="-arch $ARCH"
#export CFLAGS="$CFLAGS -mios-version-min=$DEPLOYMENT_TARGET"#-fembed-bitcode
#export CXXFLAGS="$CFLAGS -std=c++11 -stdlib=libc++"


#// 这种方式编译出来的是x86_64
#export CC=clang
#export CFLAGS="-DNDEBUG -g -O0 -pipe -fPIC -fcxx-exceptions"
#export CXX=clang++
#export CXXFLAGS="${CFLAGS} -std=c++11 -stdlib=libc++"

#export CC=clang
#export CPPFLAGS="-miphoneos-version-min=10.0 -pipe -no-cpp-precomp -I$SDKROOT/usr/include"
#export CFLAGS="$CPPFLAGS -std=c++11 -stdlib=libc++ -arch ${arch} -isysroot $SDKROOT -isystem $SDKROOT/usr/include"
#export CXX=clang++
#export CXXFLAGS="$CPPFLAGS -std=c++11 -stdlib=libc++ -arch ${arch} -isysroot $SDKROOT -isystem $SDKROOT/usr/include"


#
#MODULES="online2 ivector nnet2 lat decoder feat transform gmm thread hmm tree matrix util base itf cudamatrix fstext"
MODULES="online2 ivector nnet2 nnet3 lat lm decoder feat transform gmm hmm tree matrix util base itf cudamatrix fstext"
#MODULES="gmm sgmm"
INCLUDE_DIR=include/kaldi
mkdir -p $INCLUDE_DIR

echo "Copying include files"
LIBS=""
for m in $MODULES
do
  cd $m
  echo
  echo "BUILDING MODULE $m"
  echo
  if [[ -f Makefile ]]
  then
    make
    lib=$(ls *.a)  # this will fail (gracefully) for ift module since it only contains .h files
    LIBS+=" $m/$lib"
  fi

  echo "创建模块文件夹：$INCLUDE_DIR/$m"
  cd ..
  mkdir -p $INCLUDE_DIR/$m
  echo "拷贝文件到：$INCLUDE_DIR/$m/"
  cp -v $m/*h $INCLUDE_DIR/$m/
done

echo "LIBS: $LIBS"

LIBNAME="kaldi-ios.a"
libtool -static -o $LIBNAME $LIBS

cat >&2 << EOF

Build succeeded! 

Library is in $LIBNAME
h files are in $INCLUDE_DIR

EOF
