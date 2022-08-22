#!/bin/bash

# File Swap by Valerio Capello - http://labs.geody.com/ - GPL - r2017-01-28 fr2017-01-28
# echo 'File Swap'

if [ "$#" -eq 1 ]; then echo "swap: missing second file operand after ‘$1’"; exit 1; fi
if [ "$#" -ne 2 ]; then echo "swap: missing file operand"; exit 1; fi
doop=1;
if [ ! -e $1 ]; then echo "cannot stat ‘$1’: No such file or directory"; doop=0 ; fi
if [ ! -e $2 ]; then echo "cannot stat ‘$2’: No such file or directory"; doop=0 ; fi

if [ "$doop" -eq 1 ]; then
# echo "swapping: ‘$1’ ‘$2’";
tmpfile=`mktemp "/tmp/tXXXXXXX"` || exit 1;
rm "$tmpfile"
mv "$1" "$tmpfile"
mv "$2" "$1"
mv "$tmpfile" "$2"
# echo "done.";
fi
