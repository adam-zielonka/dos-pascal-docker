#!/bin/sh

set -e

if [ ! -f "$1" ] ; then
  echo File $1 not found
  exit 1
fi

FILE=$(basename $1)
DIR=$(dirname $1)
TITLE=$(echo $FILE | cut -d '.' -f 1)

if [[ "$2" == "--watch" ]] ; then
  echo 'Watching for file changes.'
  while true; do
    inotifywait -q -e MODIFY --format '%w' $DIR/*.[Pp][Aa][Ss] | while read FILE_TEST
    do
      while [ ! -s $FILE_TEST ] ; do true; done
      rm -fr build
      mkdir build
      cp -r `ls -Ad $DIR/* | grep -v "build"` build
      ls -1Ad build/*.[Pp][Aa][Ss] | xargs -n 1 encode.sh
      ls -1Ad build/*.[Tt][Xx][Tt] | xargs -n 1 encode.sh
      dosbox -c "MOUNT C: $PWD" -c "MOUNT D: /tpc" -c "c:" -c "CD C:\BUILD" -c "D:\TPC.EXE $FILE -B > LOG.TXT" -c "EXIT" > /dev/null
      decode.sh build/LOG.TXT
      cat build/LOG.TXT
      echo ''
      echo 'Watching for file changes.'
    done
  done
fi

rm -fr build
mkdir build
cp -r `ls -Ad $DIR/* | grep -v "build"` build
ls -1Ad build/*.[Pp][Aa][Ss] | xargs -n 1 encode.sh
ls -1Ad build/*.[Tt][Xx][Tt] | xargs -n 1 encode.sh
dosbox -c "MOUNT C: $PWD" -c "MOUNT D: /tpc" -c "c:" -c "CD C:\BUILD" -c "D:\TPC.EXE $FILE -B > LOG.TXT" -c "EXIT" > /dev/null
decode.sh build/LOG.TXT
cat build/LOG.TXT
if cat build/LOG.TXT | grep -q Error ; then exit 1 ; fi

echo Generating website...

rm -fr build/*.PAS build/*.pas build/LOG.TXT
zip -rj build/$TITLE.ZIP build/
find build -type f ! -name '*.ZIP' -delete
MD5_ZIP_SUM=$(md5sum build/$TITLE.ZIP | cut -d ' ' -f 1)
ZIP_FILE_NAME=$TITLE-$MD5_ZIP_SUM.ZIP

echo $ZIP_FILE_NAME
cp build/$TITLE.ZIP build/$ZIP_FILE_NAME

cp /web/* build/

sed -i "s/!!!TITLE!!!/$TITLE/g" build/index.html
sed -i "s/!!!ZIP_FILENAME!!!/$ZIP_FILE_NAME/g" build/index.html
sed -i "s/!!!EXE_FILENAME!!!/$TITLE.EXE/g" build/index.html

echo Website generated successfully
