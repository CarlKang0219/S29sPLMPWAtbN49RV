#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Error: Illegal number of parameters."
    exit
fi
FLAG_CC="gcc"
FLAG_INCLUDE=`itpp-config --cflags`
FLAG_LIB=`itpp-config --libs`
SRC_IN=$1
BIN_OUT=${SRC_IN%.cpp}
COMMAND="$FLAG_CC $FLAG_INCLUDE -o $BIN_OUT $SRC_IN $FLAG_LIB"
echo $COMMAND
$COMMAND
#`itpp-config --cflags` -o bpsk bpsk.cpp `itpp-config --libs`
