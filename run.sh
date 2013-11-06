#!/bin/bash

RELEASE="release"
BUILD="$RELEASE/build"
DEBUG="$RELEASE/debug"

#-----------------------------------------------
# build
#-----------------------------------------------

function build {
  function boot {
    BOOT="boot"
    nasm -f bin -o $BUILD/lba.bin $BOOT/lba.s -l $DEBUG/lba.l
    nasm -f bin -o $BUILD/hello.bin $BOOT/hello.s -l $DEBUG/hello.l
  }

  function img {
    IMG="img"
    nasm -f bin -o $BUILD/hd_img.bin $IMG/hd_img.s -l $DEBUG/hd_img.l
  }

  function all {
    boot
    img
  }

  $1
}


#-----------------------------------------------
# clear
#-----------------------------------------------

function clear {
  function boot {
    rm -rf $BUILD/*.bin $DEBUG/*.l
  }

  function img {
    rm -rf $BUILD/*.bin $DEBUG/*.l
  }

  function all {
    boot
    img
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
all
  "
}

#-----------------------------------------------
# main
#-----------------------------------------------

$1 $2
