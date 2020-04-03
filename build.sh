#!/bin/bash

rm -fr build
mkdir build
unzip 3rd-party/JS-DOS.ZIP -d build/
cp 3rd-party/TPWDB.ZIP build/TPWDB.ZIP
rm build/index.html
cp public/build.html build/index.html
zip -rj build/DESKA.ZIP src
