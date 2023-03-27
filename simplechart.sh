#!/bin/bash

# Simple Chart
xver='r2023-03-27 fr2020-10-09';
# by Valerio Capello - http://labs.geody.com/ - License: GPL v3.0


# Config

vals=( "$@" ); # Values to be rendered passed as arguments from the command line
# vals=(20 0 1 80 50 30); # Values to be rendered
if [ ${#vals[@]} -lt 1 ]; then exit 0; fi; for i in $( seq $(( ${#vals[@]} - 1 )) ); do vals[$i]="$( echo ${vals[$i]} | sed 's/[^0-9]*//g' ) "; done; # Sanitize input
# maxv=$( IFS=$'\n'; sort -nr <<< "${vals[*]}" | head --lines=1 ) ; # Max value based on the highest value in the array
# maxv=$( printf "%d\n" "${vals[@]}" | sort -nr | head --lines=1 ); # Max value based on the highest value in the array
maxv=0; for i in ${vals[@]}; do let maxv+=$i; done # Max value based on the total of all the values in the array
# maxv=0; for i in $( eval echo {0..$((${#vals[@]}-1))} ); do let maxv+=$i; done # Max value based on the total of all the values in the array
# maxw=40; # Max Width of the chart in characters 
maxw=$(tput cols); if (( $maxw >= 40 )); then maxw=$(( maxw - 30 )); fi # Max Width of the chart in characters
plotbas="|"; # Plot base character
plotbar="="; # Plot bar character
# plotchar=$plotbar; # Plot last character (No special last character)
plotchar="*"; # Plot last character
plotempty="."; # Plot empty space
drwplotbas=true; # Draw base character
drwplotempty=true; # Draw empty space
drwbars=true; # Draw bars
drwnums=true; # Print numbers
drwnpos=true; # Print position (if drwnums=true )
drwnval=true; # Print value (if drwnums=true )
drwnpct=true; # Print percent (if drwnums=true )

# Functions

strrepeat() {
nm=$2
if (( $nm > 0 )); then
st=$1
r=$(printf "%-${nm}s" "$st")
echo -n "${r// /$st}"
fi
}

strind() {
nm=$(( $3 - 1 ))
if (( $nm > 0 )); then
sp=$1
st=$2
r=$(printf "%-${nm}s" "$sp")
echo -n "${r// /$sp}$st"
elif (( $nm == 0 )); then
echo -n "$st"
fi
}


# Main

if [[ "$1" == "--help" ]]; then
echo "SimpleChart";
echo "by Valerio Capello - labs.geody.com - License: GPL v3.0";
echo ;
echo "Usage  : simplechart n1 n2 n3 ...";
echo "Example: simplechart 20 0 1 80 50 30";
echo ;
exit 0;
fi

if (( $maxv == 0 )); then maxv=1; fi
i=0;
for el in "${vals[@]}";
do
i=$(( i + 1 ))
xpc=$(( el * 100 / maxv ))
if ( $drwbars ); then
xsz=$(( el * maxw / maxv ))
if ( $drwplotbas ); then echo -n $plotbas; fi
# strrepeat "$plotchar" "$xsz"
strind "$plotbar" "$plotchar" "$xsz"
if ( $drwplotempty ); then xem=$(( maxw - xsz )); strrepeat "$plotempty" "$xem"; fi
fi
if ( $drwnums ); then
if ( $drwnpos ); then ounpos=" $i:"; else ounpos=""; fi
if ( $drwnval ); then ounval=" $el"; ounval=${ounval%% }; else ounval=""; fi
if ( $drwnpct ); then if ( $drwnval ); then ounpct=" (${xpc}%)"; else ounpct=" ${xpc}%"; fi; else ounpct=""; fi
echo "${ounpos}${ounval}${ounpct}"; # echo " $i: $el (${xpc}%)";
else
echo
fi
done
