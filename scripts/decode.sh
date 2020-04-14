#!/bin/sh

set -e

if [ -z $1 ] ; then exit 0; fi

iconv -f 852 -t utf-8 $1 > temp
mv temp $1

sed -i "s//☺/g" $1
sed -i "s//☻/g" $1
sed -i "s//♥/g" $1
sed -i "s//♦/g" $1
sed -i "s//♣/g" $1
sed -i "s//♠/g" $1
sed -i "s//•/g" $1
sed -i "s//◘/g" $1
# sed -i "s//○/g" $1
# sed -i "s//◙/g" $1
sed -i "s//♂/g" $1
# sed -i "s//♀/g" $1
# sed -i "s//♪/g" $1
sed -i "s//♫/g" $1
sed -i "s//☼/g" $1
sed -i "s//►/g" $1
sed -i "s//◄/g" $1
sed -i "s//↕/g" $1
sed -i "s//‼/g" $1
sed -i "s//¶/g" $1
sed -i "s//§/g" $1
sed -i "s//▬/g" $1
sed -i "s//↨/g" $1
sed -i "s//↑/g" $1
sed -i "s//↓/g" $1
sed -i "s//→/g" $1
sed -i "s//←/g" $1
sed -i "s//∟/g" $1
sed -i "s//↔/g" $1
sed -i "s//▲/g" $1
sed -i "s//▼/g" $1
