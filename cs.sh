#!/bin/bash

# cs (aka cl) - Change and List Directory
# r2020-11-13 fr2020-09-28
# by Valerio Capello - https://labs.geody.com/ - License: GPL v3.0
# alias {cs,cl}=". /var/scripts/cs.sh"

if [ $# -eq 0 ]; then
dirx="."
else
dirx=$1
fi

# echo $dirx

if [[ -d $dirx ]]; then
cd "$dirx"
pwd
ls -aF --group-directories-first --color=auto
elif [[ -f $dirx ]]; then
echo "'$dirx' is a file, not a directory."
# exit 1 # Since it's executed from the shell, it would quit the shell
else
echo "'$dirx' not found."
# exit 1 # Since it's executed from the shell, it would quit the shell
fi
