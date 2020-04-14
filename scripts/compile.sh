#!/bin/sh

set -e

FILE=$1
SRC_DIR=$2
WORK_DIR=$3

rm -fr build
mkdir build
cp -r `ls -Ad $SRC_DIR/* | grep -v "build"` build
ls -1Ad build/*.[Pp][Aa][Ss] 2> /dev/null | xargs -n 1 encode.sh
ls -1Ad build/*.[Tt][Xx][Tt] 2> /dev/null | xargs -n 1 encode.sh
dosbox -c "MOUNT C: $WORK_DIR" -c "MOUNT D: /tpc" -c "c:" -c "CD C:\BUILD" -c "D:\TPC.EXE $FILE -B > LOG.TXT" -c "EXIT" > /dev/null
decode.sh build/LOG.TXT
cat build/LOG.TXT
