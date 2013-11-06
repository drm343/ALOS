#!/bin/bash

RELEASE="release"
BUILD="$RELEASE/build"
DEBUG="$RELEASE/debug"

#-----------------------------------------------
# boot
#-----------------------------------------------

function boot {
  BOOT="boot"
  function build {
    nasm -f bin -o $BUILD/lba.bin $BOOT/lba.s -l $DEBUG/lba.l
    nasm -f bin -o $BUILD/hello.bin $BOOT/hello.s -l $DEBUG/hello.l
  }
  
  function clear {
    rm -rf $BUILD/*.bin $DEBUG/*.l
  }
  
  $1
}

#-----------------------------------------------
# img
#-----------------------------------------------

function img {
  IMG="img"
  function build {
    nasm -f bin -o $BUILD/hd_img.bin $IMG/hd_img.s -l $DEBUG/hd_img.l
  }
  
  function clear {
    rm -rf $BUILD/*.bin $DEBUG/*.l
  }
  
  $1
}

boot $1
#img $1
