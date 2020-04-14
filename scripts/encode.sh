#!/bin/sh

set -e

sed -i "s/☺//g" $1
sed -i "s/☻//g" $1
sed -i "s/♥//g" $1
sed -i "s/♦//g" $1
sed -i "s/♣//g" $1
sed -i "s/♠//g" $1
sed -i "s/•//g" $1
sed -i "s/◘//g" $1
# sed -i "s/○//g" $1
# sed -i "s/◙//g" $1
sed -i "s/♂//g" $1
# sed -i "s/♀//g" $1
# sed -i "s/♪//g" $1
sed -i "s/♫//g" $1
sed -i "s/☼//g" $1
sed -i "s/►//g" $1
sed -i "s/◄//g" $1
sed -i "s/↕//g" $1
sed -i "s/‼//g" $1
sed -i "s/¶//g" $1
sed -i "s/§//g" $1
sed -i "s/▬//g" $1
sed -i "s/↨//g" $1
sed -i "s/↑//g" $1
sed -i "s/↓//g" $1
sed -i "s/→//g" $1
sed -i "s/←//g" $1
sed -i "s/∟//g" $1
sed -i "s/↔//g" $1
sed -i "s/▲//g" $1
sed -i "s/▼//g" $1

unix2dos $1
iconv -f utf-8 -t 852 $1 > temp
mv temp $1
