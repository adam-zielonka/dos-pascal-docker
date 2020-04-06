#!/bin/sh

set -x

FILE=$1
TITLE=$(echo $1 | cut -d '.' -f 1)
rm -fr build
cp -r src build
dosbox -c "MOUNT C: $PWD" -c "MOUNT D: /tpc" -c "c:" -c "CD C:\BUILD" -c "D:\TPC.EXE $1 > LOG.TXT" -c "EXIT"
cat build/LOG.TXT
if cat build/LOG.TXT | grep -q Error ; then exit 500 ; fi
zip -rj build/$TITLE.ZIP build/

MD5_ZIP_SUM=$(md5sum build/$TITLE.ZIP | cut -d ' ' -f 1)
ZIP_FILE_NAME=$1-$MD5_ZIP_SUM.ZIP
echo $ZIP_FILE_NAME
cp build/$TITLE.ZIP build/$ZIP_FILE_NAME

cp /web/* build/

sed -i "s/!!!TITLE!!!/$TITLE/g" build/index.html
sed -i "s/!!!ZIP_FILENAME!!!/$ZIP_FILE_NAME/g" build/index.html
sed -i "s/!!!EXE_FILENAME!!!/$TITLE.EXE/g" build/index.html
