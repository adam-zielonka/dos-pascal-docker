set -e

echo Generating website...

TITLE=$1

rm -fr build/*.[Pp][Aa][Ss] build/*.[Tt][Pp][Uu] build/LOG.TXT
zip -rj build/$TITLE.ZIP build/
find build -type f ! -name '*.ZIP' -delete
MD5_ZIP_SUM=$(md5sum build/$TITLE.ZIP | cut -d ' ' -f 1)
ZIP_FILE_NAME=$TITLE-$MD5_ZIP_SUM.ZIP

echo $ZIP_FILE_NAME
cp build/$TITLE.ZIP build/$ZIP_FILE_NAME

cp /web/* build/

mkdir -p build/full-screen
mv build/full-screen.html build/full-screen/index.html
sed -i -e "s/!!!TITLE!!!/$TITLE/g" \
       -e "s/!!!ZIP_FILENAME!!!/$ZIP_FILE_NAME/g" \
       -e "s/!!!EXE_FILENAME!!!/$TITLE.EXE/g" build/index.html build/full-screen/index.html

echo Website generated successfully
