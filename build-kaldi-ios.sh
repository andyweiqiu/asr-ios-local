#!/bin/bash

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

  echo "create dir：$INCLUDE_DIR/$m"
  cd ..
  mkdir -p $INCLUDE_DIR/$m
  echo "copy dir to：$INCLUDE_DIR/$m/"
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
