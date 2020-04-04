#!/bin/sh

set -x

FILE=$1
rm -fr build
cp -r src build
dosbox -c "MOUNT C: $PWD" -c "MOUNT D: /tp" -c "c:" -c "CD C:\BUILD" -c "D:\BIN\TPC.EXE $1 > LOG.TXT" -c "EXIT"
cat build/LOG.TXT
zip -rj build/DESKA.ZIP build/
unzip 3rd-party/js-dos.zip -d build/
cp web/index.html build/index.html
