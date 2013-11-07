#!/bin/bash

SRC="src"
DOC="doc"
INCLUDE="include"
LIB="lib"
BUILD="build"

#-----------------------------------------------
# build
#-----------------------------------------------

function build {
  function _nasm {
    nasm $NASM_SRC/$1.s -I"$NASM_LIB" -f bin -o $NASM_BUILD/$1.bin -l $NASM_DEBUG/$1.l
  }

  function boot {
    NASM_SRC="$SRC/boot"
    NASM_LIB="$LIB/nasm/"
    NASM_BUILD="$LIB/bin"
    NASM_DEBUG="$DOC/debug"

    _nasm lba
    _nasm hello
    echo "build build done"
  }

  function img {
    NASM_SRC="$LIB/bin"

    dd if=/dev/zero of=$NASM_SRC/zero.img bs=512 count=2878
    cat $NASM_SRC/lba.bin $NASM_SRC/hello.bin $NASM_SRC/zero.img > $BUILD/hd_img.img

    echo "build img done"
  }

  function all {
    boot
    img
    echo "build all done"
  }

  $1
}


#-----------------------------------------------
# clear
#-----------------------------------------------

function clear {
  function boot {
    rm -rf $LIB/bin/*
    echo "clear boot done"
  }

  function img {
    rm -rf $BUILD/*.bin 
    echo "clear img done"
  }

  function debug {
    rm -rf $DOC/debug/*.l
    echo "clear debug done"
  }

  function all {
    boot
    img
    debug
    echo "clear all done"
  }

  $1
}

#-----------------------------------------------
# help
#-----------------------------------------------

function help {
  echo "
run [command] [target]:

[command]:
build
clear
help

[target]:
boot
img
all"
}

#-----------------------------------------------
# main
#-----------------------------------------------

if [ $1 ] && [ $2 ]
then
  $1 $2
else
  help
fi
