#!/bin/sh

set -e

if [ ! -f "$1" ] ; then
  echo File $1 not found
  exit 1
fi

FILE=$(basename $1)
DIR=$(dirname $1)
TITLE=$(echo $FILE | cut -d '.' -f 1)

compile.sh $FILE $DIR $PWD
cat build/LOG.TXT | grep -q Error || website.sh $TITLE

if [[ "$2" == "--watch" ]] ; then
  echo 'Watching for file changes.'
  while true; do
    inotifywait -q -e MODIFY --format '%w' $DIR/*.[Pp][Aa][Ss] | while read FILE_TEST
    do
      while [ ! -s $FILE_TEST ] ; do true; done
      compile.sh $FILE $DIR $PWD
      cat build/LOG.TXT | grep -q Error || website.sh $TITLE
      echo ''
      echo 'Watching for file changes.'
    done
  done
fi

if cat build/LOG.TXT 2> /dev/null | grep -q Error ; then exit 1 ; fi
