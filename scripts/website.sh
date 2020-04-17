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

sed -i "s/!!!TITLE!!!/$TITLE/g" build/index.html
sed -i "s/!!!ZIP_FILENAME!!!/$ZIP_FILE_NAME/g" build/index.html
sed -i "s/!!!EXE_FILENAME!!!/$TITLE.EXE/g" build/index.html

echo Website generated successfully
