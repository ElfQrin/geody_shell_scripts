#!/bin/bash

# Bell # Play the Bell
# r2022-08-24 fr2017-02-01
# by Valerio Capello - http://labs.geody.com/ - GPL
# alias bell="PATH/bell.sh"

# Get Parameters
xtimes="$1"


# Config

xdelay=0.5; # Delay


# Main

if [ "$#" -eq 0 ] || [ -z "$xtimes" ]; then xtimes=1; fi
if [ "$xtimes" -le 0 ]; then xtimes=0;
else
for ((i=1; i <= $xtimes; i++)); do
# echo -n "$i ";
printf '\7'; sleep $xdelay;
done
# echo
fi
