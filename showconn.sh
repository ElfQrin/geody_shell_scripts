#!/bin/bash

# Conn (showconn)
# r2021-07-15 fr2018-05-12
# by Valerio Capello - https://labs.geody.com/ - License: GPL v3.0

STARTTIME=$(date);
STARTTIMESEC=$(date +%s);

# Config

cportnums=('22' '80' '443'); # Port Numbers
cportnams=(); cportnams[22]='SSH'; cportnams[80]='HTTP'; cportnams[443]='HTTPS'; # Port Labels (Names)
shwcpuavld=true; # Show CPU Average Load
shwmem=true; # Show Memory Usage
shwusehr=true; # Show Memory Usage in Human Readable Format
maxtim=-1; # Quit after cycling given times ( -1 : Infinite )
maxsec=-1; # Quit after given seconds ( -1 : Infinite )
cls=1; # Clear Screen before showing any cycle (1: True, 0: False)
tsminon="\e[1;34m"; tsminof="\e[0m"; # Color for min value (on/off)
tsmaxon="\e[1;31m"; tsmaxof="\e[0m"; # Color for max value (on/off)
tsavgon="\e[0;33m"; tsavgof="\e[0m"; # Color for average value (on/off)


# Functions

apphdr() {
echo "Conn";
echo "by Valerio Capello - labs.geody.com - License: GPL v3.0";
}


# Get Parameters

if [ "$#" -eq 1 ]; then
if [ $1 -gt 0 ]; then maxtim=$1 ; fi
fi


# Main

cnti=0;
while :
do
(( ++cnti ))

fne=$( netstat -an );

conntot=$(printf "$fne\n" | awk '{print $6}' | grep 'ESTABLISHED' | wc -l);
conntottcp=$(printf "$fne\n" | awk '{print $1 " " $6}' | grep 'tcp' | grep 'ESTABLISHED' | wc -l);
conntotudp=$(printf "$fne\n" | awk '{print $1 " " $6}' | grep 'udp' | grep 'ESTABLISHED' | wc -l);

gpts=(); tgpts=0;
if [ ${#cportnums[@]} -gt 0 ]; then
for pt in "${cportnums[@]}"
do
gpts[$pt]=$(printf "$fne\n" | awk '{print $4 " " $6}' | grep ":$pt " | grep 'ESTABLISHED' | wc -l);
(( tgpts+=gpts[pt] ))
done
# connotr=$(printf "$fne\n" | awk '{print $4 " " $6}' | grep 'ESTABLISHED' | wc -l); connotr="$(( $connotr-$tgpts ))";
connotr="$(( $conntot-$tgpts ))";
fi

if [ "$cnti" -eq 1 ]; then
conntotsm="$conntot"; conntotmx="$conntot"; conntotmn="$conntot"; conntotav="$conntot";
conntottcpsm="$conntottcp"; conntottcpmx="$conntottcp"; conntottcpmn="$conntottcp"; conntottcpav="$conntottcp";
conntotudpsm="$conntotudp"; conntotudpmx="$conntotudp"; conntotudpmn="$conntotudp"; conntotudpav="$conntotudp";

if [ ${#cportnums[@]} -gt 0 ]; then
for pt in "${cportnums[@]}"
do
connpsm[$pt]="${gpts[pt]}"; connpmx[$pt]="${gpts[pt]}"; connpmn[$pt]="${gpts[pt]}"; connpav[$pt]="${gpts[pt]}";
done
connotrsm="$connotr"; connotrmx="$connotr"; connotrmn="$connotr"; connotrav="$connotr";
fi

else

if [ "$conntot" -gt "$conntotmx" ]; then
conntotmx=$conntot;
fi
if [ "$conntot" -lt "$conntotmn" ]; then
conntotmn=$conntot;
fi
conntotsm="$(( $conntotsm + $conntot ))";
conntotav="$(( $conntotsm / $cnti ))";

if [ "$conntottcp" -gt "$conntottcpmx" ]; then
conntottcpmx=$conntottcp;
fi
if [ "$conntottcp" -lt "$conntottcpmn" ]; then
conntottcpmn=$conntottcp;
fi
conntottcpsm="$(( $conntottcpsm + $conntottcp ))";
conntottcpav="$(( $conntottcpsm / $cnti ))";

if [ "$conntotudp" -gt "$conntotudpmx" ]; then
conntotudpmx=$conntotudp;
fi
if [ "$conntotudp" -lt "$conntotudpmn" ]; then
conntotudpmn=$conntotudp;
fi
conntotudpsm="$(( $conntotudpsm + $conntotudp ))";
conntotudpav="$(( $conntotudpsm / $cnti ))";

if [ ${#cportnums[@]} -gt 0 ]; then
for pt in "${cportnums[@]}"
do
if [ "${gpts[pt]}" -gt "${connpmx[pt]}" ]; then
connpmx[$pt]="${gpts[pt]}";
fi
if [ "${gpts[pt]}" -lt "${connpmn[pt]}" ]; then
connpmn[$pt]="${gpts[pt]}";
fi
connpsm[$pt]="$(( ${connpsm[pt]} + ${gpts[pt]} ))";
connpav[$pt]="$(( ${connpsm[pt]} / $cnti ))";
done

if [ "$connotr" -gt "$connotrmx" ]; then
connotrmx=$connotr;
fi
if [ "$connotr" -lt "$connotrmn" ]; then
connotrmn=$connotr;
fi
connotrsm="$(( $connotrsm + $connotr ))";
connotrav="$(( $connotrsm / $cnti ))";
fi

fi

if [ $maxtim -ne 1 ]; then
if [ $cls -eq 1 ]; then clear; fi
fi

if [ $cls -eq 1 ] || [ $cnti -eq 1 ]; then
apphdr; echo;
echo "Estabilished Connections"; echo;
fi

CTIMESEC=$(date +%s)
echo "Start Time: $STARTTIME";
echo "Curr. Time: $(date)";
echo "Cycles: $cnti - Seconds elapsed: $(($CTIMESEC - $STARTTIMESEC))";
echo;
echo -n "Total: $conntot";
if [ $maxtim -ne 1 ]; then echo -n " - "; echo -ne "$tsminon"; echo -n "Min: $conntotmn"; echo -ne "$tsminof"; echo -n " , "; echo -ne "$tsmaxon"; echo -n "Max: $conntotmx"; echo -ne "$tsmaxof"; echo -n " , "; echo -ne "$tsavgon"; echo -n "Avg: $conntotav"; echo -e "$tsavgof"; else echo; fi
echo -n "Total TCP: $conntottcp";
if [ $maxtim -ne 1 ]; then echo -n " - "; echo -ne "$tsminon"; echo -n "Min: $conntottcpmn"; echo -ne "$tsminof"; echo -n " , "; echo -ne "$tsmaxon"; echo -n "Max: $conntottcpmx"; echo -ne "$tsmaxof"; echo -n " , "; echo -ne "$tsavgon"; echo -n "Avg: $conntottcpav"; echo -e "$tsavgof"; else echo; fi
echo -n "Total UDP: $conntotudp";
if [ $maxtim -ne 1 ]; then echo -n " - "; echo -ne "$tsminon"; echo -n "Min: $conntotudpmn"; echo -ne "$tsminof"; echo -n " , "; echo -ne "$tsmaxon"; echo -n "Max: $conntotudpmx"; echo -ne "$tsmaxof"; echo -n " , "; echo -ne "$tsavgon"; echo -n "Avg: $conntotudpav"; echo -e "$tsavgof"; else echo; fi

if [ ${#cportnums[@]} -gt 0 ]; then
for pt in "${cportnums[@]}"
do
echo -n "Port $pt";
if [ -n "${cportnams[pt]}" ]; then echo -n " (${cportnams[pt]})"; fi
echo -n ": ${gpts[pt]}";
if [ $maxtim -ne 1 ]; then echo -n " - "; echo -ne "$tsminon"; echo -n "Min: ${connpmn[pt]}"; echo -ne "$tsminof"; echo -n " , "; echo -ne "$tsmaxon"; echo -n "Max: ${connpmx[pt]}"; echo -ne "$tsmaxof"; echo -n " , "; echo -ne "$tsavgon"; echo -n "Avg: ${connpav[pt]}"; echo -e "$tsavgof"; else echo; fi
done
echo -n "Other connections: $connotr"; if [ $maxtim -ne 1 ]; then echo -n " - "; echo -ne "$tsminon"; echo -n "Min: $connotrmn"; echo -ne "$tsminof"; echo -n " , "; echo -ne "$tsmaxon"; echo -n "Max: $connotrmx"; echo -ne "$tsmaxof"; echo -n " , "; echo -ne "$tsavgon"; echo -n "Avg: $connotrav"; echo -e "$tsavgof"; else echo; fi
fi

if ( $shwcpuavld ); then
echo; echo -n "CPU average load (Cores: "; grep -c 'processor' /proc/cpuinfo  | tr -d '\n' ; echo -n "): "; uptime | awk -F'[a-z]:' '{print $2}' | xargs | awk '{print "1 m: "$1" 5 m: "$2" 15 m: "$3}';
fi

if ( $shwmem ); then
echo; 
if ( $shwusehr ); then
free -h | xargs | awk '{print "Memory: Size: "$8" Used: "$9" Free: "$10" Avail: "$13}';
swapon --show --noheadings --raw | xargs | awk '{print "Swap File: Dev: "$1" Total: "$3" Used: "$4}';
else
free;
fi
fi

if [ $cls -eq 0 ]; then echo; echo; fi

if [ $maxtim -ne 1 ]; then
read -s -t 1 -N 1 input
if [[ $input = 'q' ]] || [[ $input = 'Q' ]] || [[ $input = $'\e' ]]; then
echo;
break;
fi
fi

if [ $maxtim -gt -1 -a $cnti -ge $maxtim ]; then
echo;
break;
fi

if [ $maxsec -gt -1 -a $(($CTIMESEC - $STARTTIMESEC)) -ge $maxsec ]; then
echo;
break;
fi

done
