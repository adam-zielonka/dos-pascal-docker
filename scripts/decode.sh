#!/bin/sh

set -e

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
