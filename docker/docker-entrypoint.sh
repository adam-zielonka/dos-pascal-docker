#!/bin/sh

rm -fr build
cp -r src build
dosbox
cat build/LOG.TXT
zip -rj build/DESKA.ZIP build/
unzip 3rd-party/js-dos.zip -d build/
cp public/index.html build/index.html
